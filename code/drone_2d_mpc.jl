using JuMP
using Plots
import Ipopt

function generate_target_and_constraints(box_width)
    N_points = 1000
    t = LinRange(0, 1.0, N_points)
    target_x = cos.(2 * pi * t)
    target_y = sin.(2 * pi * t)

    constraint_x = [-box_width * ones(N_points); LinRange(-box_width, box_width, N_points); box_width * ones(N_points); LinRange(-box_width, box_width, N_points)]
    constraint_y = [LinRange(-box_width, box_width, N_points); box_width * ones(N_points); LinRange(-box_width, box_width, N_points); -box_width * ones(N_points)]

    return target_x, target_y, constraint_x, constraint_y
end
function calculate_state_derivatives(s, u, model_constants)
    g, m, l, J = model_constants
    ddx = (u[1] + u[2]) / m * sin(s[3])
    ddz = (u[1] + u[2]) / m * cos(s[3]) - g
    ddtheta = (u[2] - u[1]) * l / (sqrt(2) * J)
    return [s[4], s[5], s[6], ddx, ddz, ddtheta]
end
function integrate_runge_kutta_4(f, s, u, dt)
    k1 = f(s, u)
    k2 = f(s + dt / 2 * k1, u)
    k3 = f(s + dt / 2 * k2, u)
    k4 = f(s + dt * k3, u)
    return s + dt / 6 * (k1 + 2 * k2 + 2 * k3 + k4)
end
function generate_target_trajectory(t, n, dt)
    s_d = zeros(n, 2)
    for i in 1:n
        s_d[i, 1] = cos(pi / 2 * (t + i * dt))
        s_d[i, 2] = sin(pi / 2 * (t + i * dt))
    end
    return s_d
end
function model_predictive_control(t, s_current, s_old, u_old, model_constants, constraint_constants, mpc_solver_constants)
    g, m, l, J = model_constants

    box_width, u_min, u_max = constraint_constants

    N_state, T_final, N_iter, Q, R = mpc_solver_constants

    dt = T_final / N_iter

    s_d = generate_target_trajectory(t, N_iter, dt)

    s_0 = [s_current; s_old[3:end, :]; s_old[end:end, :]]
    s_0[end, 1:2] = s_d[end, 1:2]

    u_0 = [u_old; u_old[end:end, :]]
    model = Model(Ipopt.Optimizer)
    set_silent(model)
    @variables(model, begin
        s[i=1:N_iter, j=1:6], (start = s_0[i, j])
        u_min <= u[i=1:N_iter, j=1:2] <= u_max, (start = u_0[i, j])
    end)
    @NLexpression(model, ddx[j=1:N_iter], (u[j, 1] + u[j, 2]) / m * sin(s[j, 3]))
    @NLexpression(model, ddz[j=1:N_iter], (u[j, 1] + u[j, 2]) / m * cos(s[j, 3]) - g)
    @NLexpression(model, ddtheta[j=1:N_iter], (u[j, 2] - u[j, 1]) * l / (sqrt(2) * J))

    # State constraints
    @constraint(model, [i in 1:N_iter], -box_width <= s[i, 1] <= box_width)
    @constraint(model, [i in 1:N_iter], -box_width <= s[i, 2] <= box_width)

    # Dynamics constraints
    @constraint(model, [i in 1:N_iter-1], s[i+1, 1] - s[i, 1] == 0.5 * dt * (s[i, 4] + s[i+1, 4]))
    @constraint(model, [i in 1:N_iter-1], s[i+1, 2] - s[i, 2] == 0.5 * dt * (s[i, 5] + s[i+1, 5]))
    @constraint(model, [i in 1:N_iter-1], s[i+1, 3] - s[i, 3] == 0.5 * dt * (s[i, 6] + s[i+1, 6]))
    @NLconstraint(model, [i in 1:N_iter-1], s[i+1, 4] - s[i, 4] == 0.5 * dt * (ddx[i] + ddx[i+1]))
    @NLconstraint(model, [i in 1:N_iter-1], s[i+1, 5] - s[i, 5] == 0.5 * dt * (ddz[i] + ddz[i+1]))
    @NLconstraint(model, [i in 1:N_iter-1], s[i+1, 6] - s[i, 6] == 0.5 * dt * (ddtheta[i] + ddtheta[i+1]))

    for i in 1:N_state
        fix(s[1, i], s_0[1, i], force=true)
    end

    @NLobjective(model, Min, sum(R * (u[i, 1]^2 + u[i, 2]^2) + Q * ((s[i, 1] - s_d[i, 1])^2 + (s[i, 2] - s_d[i, 2])^2) for i in 1:N_iter))
    optimize!(model)
    return value.(s), value.(u)
end

function simulation_loop(model_constants, constraint_constants, mpc_solver_constants, simulation_constants)
    s_current = [constraint_constants.box_width - 0.1, 0.0, 0.0, 0.0, 0.0, 0.0]'
    s_filtered = s_current
    time = 0.0
    s_d = generate_target_trajectory(time, mpc_solver_constants.N_iter, simulation_constants.dt)
    s_old = zeros(100, 6)
    s_old[:, 1] = LinRange(s_current[1], s_d[end, 1], 100)
    s_old[:, 2] = LinRange(s_current[2], s_d[end, 2], 100)
    u_old = zeros(100, 2)

    s_history = Vector{Vector{Float64}}()
    u_history = Vector{Vector{Float64}}()
    push!(s_history, s_current[1, :])
    push!(u_history, u_old[1, :])
    N_simulation = Int(simulation_constants.T_final / simulation_constants.dt)
    for i in 1:N_simulation
        state_noise = simulation_constants.noise_level * randn(6)'
        state_noise[1, 3:end] .= 0.0
        s, u = model_predictive_control(time, s_filtered, s_old, u_old, model_constants, constraint_constants, mpc_solver_constants)
        time += simulation_constants.dt
        s_current = integrate_runge_kutta_4((s, u) -> calculate_state_derivatives(s, u, model_constants), s_current[1, :], u[1, :], simulation_constants.dt)'
        s_filtered = (1.0 - simulation_constants.low_pass_factor) * s_filtered + simulation_constants.low_pass_factor * (s_current + state_noise)
        push!(s_history, s_current[1, :])
        push!(u_history, u[1, :])
        s_old = s
        u_old = u
    end
    s_history = hcat(s_history...)'
    u_history = hcat(u_history...)'
    return s_history, u_history
end

model_constants = (g=9.81, m=1, l=0.3, J=0.2 * 1 * 0.3 * 0.3)
constraint_constants = (box_width=0.9, u_min=0.2 * model_constants.g / model_constants.m, u_max=0.6 * model_constants.g / model_constants.m)
mpc_solver_constants = (N_state=6, T_final=1.0, N_iter=100, Q=10000.0, R=1.0)
simulation_constants = (T_final=5.0, dt=0.01, noise_level=0.03, low_pass_factor=0.9)
s, u = simulation_loop(model_constants, constraint_constants, mpc_solver_constants, simulation_constants)

target_x, target_y, constraint_x, constraint_y = generate_target_and_constraints(constraint_constants.box_width)
p = plot(target_x, target_y, label="Target trajectory", legend=:topright, size=(600, 600), xlabel="x", ylabel="z")
p = scatter!(constraint_x, constraint_y, label="Constraint", markersize=0.2)
p = scatter!(s[:, 1], s[:, 2], label="Actual trajectory", color=:red)
display(p)