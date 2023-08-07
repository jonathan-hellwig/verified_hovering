#import "ieee_template.typ": ieee
#let title = "Formal Verification of a Quadrotor UAV: A Comparison of Reachability Analysis and Theorem Proving"
#let abstract = [
    In recent years, the use of Unmanned Aerial Vehicles (UAVs) has increased significantly in applications such as surveillance, search and rescue, and package delivery. Ensuring safety in close proximity to humans is a major challenge for UAVs. Theorem proving and reachability analysis provide a way to obtain safety guarantees for controllers of cyber-physical systems. While there has been work on both reachability analysis and theorem proving there is no work comparing them directly. In this paper, we conduct a case study to compare the two formal verification approaches to verify the safety of a  controller for a quadrotor UAV. We use the KeYmera X theorem prover and the reachability analysis tool SpaceEx. Our findings reveal that the theorem prover effectively verifies controller safety, while the reachability analysis tool falls short in verifying the same.
]
#let keywords = [
    UAV, Quadrotor, Formal verification, Theorem proving, Reachability analysis, KeYmera X, SpaceEx
]
#let bibliography_file = "bibliography.bib"
#show: doc => ieee(title, abstract,
 keywords,
 bibliography_file,
doc)
 
// = INTRODUCTION
// Theorem prover KeYmera X @KeYmaera.   

= RELATED WORK
In recent years, significant efforts have been dedicated to the risks associated with UAVs #cite("izadi2021quantitative", "namian2021revealing", "hartmann2013vulnerability", "weibel2004safety", "altawy2016security"). While some works focus on security and privacy of UAVs @altawy2016security, other works focus on safe operation of UAVs #cite("izadi2021quantitative", "namian2021revealing", "hartmann2013vulnerability", "weibel2004safety"). The necessary level of safety assurance varies across different fields of application. For example, researchers have explored the deployment of drones for tasks such as package delivery, traffic monitoring, emergency response @mohta2016quadcloud and precision agriculture @merkert2020managing. While certain researchers propose approaches intended to satisfy safety requirements, such methodologies prove inadequate when conducting operations in close proximity to humans beings. In this work, we focus on formal analysis methods that offer verifiable safety guarantees. Concerning cyber-physical systems, formal verification methodologies diverge based on the degree of abstraction. These methodologies encompass verification at the implementation level, as demonstrated by @schumann2006autonomy, and verification at the level of an abstract system model. In the realm of abstract model verification, two analytical techniques have arisen: reachability analysis, as exemplified by #cite("frehse2022symbolic", "althoff2021set"), and theorem proving, as showcased by the work of KeYmaera @KeYmaera.

Reachability analysis involves the explicitly computation of approximations for the set of reachable states, starting from an initial set. These approximation of reachable sets are compared to safety specifications. One key advantages of reachability analysis lies in its self-sufficiency once the model is fully defined, no further intervention of the user is required. However, reachability analysis is limited to finite-time horizon piecewise affine-linear dynamics and is in general undecidable #cite("althoff2021set"). Reachability techniques find application during system runtime because safety guarantees cannot be computed ahead of time. Recent work have focused on speeding up the computation of reachable sets by using different set representations and leveraging heuristics to reduce step count. Tools like SpaceEx @frehse2011spaceex, Flow\* @chen2013flow, DryVR @fan2017dryvr and PHAVer @frehse2005phaver are all based on the idea of computing reachable sets. Their distinctions lie in the model's specification language, and the most recent tool DryVR does not require an explicit system model. DryVR makes use of recent advances in learning methods and is adept at verify black box systems by using traces from a simulated system.

On the contrary, theorem proving represents an offline technique centered on finding invariants within a system to prove adherence to safety specification. The advantage of theorem proving lies in its ability guarantee system safety for an infinite time horizon @KeYmaera. However, this method requires a high level of expertise and remains applicable to moderately sized systems. Platzer et al. have developed "KeYmera X" @KeYmaera, a tool that makes use of differential dynamic logic for hybrid systems specification and safety property specification. The tool makes use of the Mathematica @Mathematica reasoning engine to automate segments of safety proofs. One shortcoming of offline theorem proving is the potential divergence of the real system's behavior the model employed in the proof. In a follow up work, Mitsch and Platzer developed ModelPlex @mitsch2016modelplex, a tool which generates a runtime monitor for the system to check conformity with the model.

While various works focus on either reachability analysis or theorem proving, a gap exists where these methods are directly compared terms of real-world feasibility. Addressing this gap, we use a benchmark problem of a 2D quadrotor UAV navigating a trajectory within a confined square, sourced from Safe-control-gym @yuan2021safe. We implement a model predictive controller for the quadrotor and use both KeYmera X and SpaceEx to verify the system's safety. By comparing the outcomes of these two methods, we show their respective strengths and limitations.

// - there are different levels of safety requirements for UAVs (Brunke et al.)
// - this work focues on the hightest level: constraint satisfaction guarantees
// - verification for UAVs exist on different levels
//     - formal verification of hybrid system
//     - verification of implmentation to detect bugs
//         - experimental evaluation
//         - simulation
//         - static analysis of code
// - formal verification techniques belong to analysis methods 
// - two branches of fomral verification for hybrid systems
//     - reachability analysis (KOCHDUMPER et al.)
//         - set propagation techniques
//         - tools: SpaceEx, Flow(star), DryVR, PHAVer
//         - advances in recent years to speed up computation
//         - advantages:
//             - no expertiese beyond the specification of the system
//         - limitations:
//             - affine linear dynamics
//             - finite time horizon
//             - computationally expensive
//     - theorem proving
//         - tools: KeYmaera X, HyTech, ModelPlex -> runtime monitoring
//         - advantages:
//             - offline computation
//         - limitations:
//             - limited to small systems
//             - high level of expertise required
// - control strategies that make use of the analysis methods
//     - action masking
//     - action replacement
//         - simplex
//     - action projection
// - works to define benchmarks for safety verification
//     - Brunke et al.
// = Methodology
// == 2D Quadrotor Model
// The state space of the quadrotor is defined as
// $
// x = vec(x_Q, dot(x)_Q, \R^I_B, omega)
// $
// It is easy to see that the dynamics of the 2D quadrotor are a special case of the general dynamics given by 
// $
// dot(x) = vec(dot(x)_Q, f/m R^I_B e_3 - g e_3, R^I_B omega_(times), J^(-1) (tau - omega times J omega)).
// $
// The dynamics of the 2D quadrotor are given by the following equations 
// $
// dot.double(x) &= sin theta (f_1 + f_2) / m \
// dot.double(z) &= cos theta (f_1 + f_2) / m - g \
// dot.double(theta) &= (f_2 - f_1) / I_(y,y)
// $
// where $u = [f_1, f_2]$ are the thrusts generated by the propellers, $m$ is the mass of the quadrotor, $g$ is the gravitational acceleration and $J_(y,y)$ is the moment of inertia of the quadrotor about the $y$-axis.

// = Results




