#import "ieee_template.typ": ieee
#let title = "Formal Verification of a Quadrotor UAV: A Comparison of Reachability Analysis and Theorem Proving"
#let abstract = [
    In recent years, the use of Unmanned Aerial Vehicles (UAVs) has increased significantly in applications such as surveillance, search and rescue, and package delivery. Ensuring savety in close proximity to humans is a major challenge for UAVs. Theorem proving and reachability analysis provide a way to obtain safety gurantees for controllers of cyber-physcial systems. While there has been work on both reachability analysis and theorem proving there is no work comparing them directly. In this paper, we conduct a case study to compare the two formal verification approaches to verifiy the safety of a  controller for a quadrotor UAV. We use the KeYmera X theorem prover and the reachability analysis tool SpaceEx. Further, we conduct an experimental evaluation of the controller on a real UAV. Our results show that while the theorem prover is able to verify the safety of the controller, the reachability analysis tool is not able to verify the safety of the controller.
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
In recent years there has been a lot of work on the risks of UAVs #cite("izadi2021quantitative", "namian2021revealing", "hartmann2013vulnerability", "weibel2004safety", "altawy2016security"). While some works focus on security and privacy of UAVs @altawy2016security, other works focus on safe operation of UAVs #cite("izadi2021quantitative", "namian2021revealing", "hartmann2013vulnerability", "weibel2004safety"). Depending on the field of application different levels of safety assurance are required. For example, there have been works that prose to use drones for package delivery, traffic monitoring, emergy respone @mohta2016quadcloud and precision agriculture @merkert2020managing. While some works introduce methods that are encouraged to statisfy safety requirements, this is not acceptable when operating close to humans. In this work we focus on formal analysis methods that come with provable safety gurantees. In the case of cyber-physcial sytems, formal verification techniques differ on the level of abstraction: verification at the level of implementation @schumann2006autonomy and verification at the level of an abstract system model. On the front of abstract model verification two main analysis methods have emerged: reachability analysis #cite("frehse2022symbolic", "althoff2021set") and theorem proving @KeYmaera.

Reachability analysis explicitly computates approximations of the set of reachable states given an initial set. These approximation of reachable sets are compared to the safety specifications. One of the main advantages of reachability analysis is that once the model is fully specified no further intervention of the user is required. However, reachability analysis is limited to finite-time horizion piecewise affine-linear dynamics and is in general undecidable #cite("althoff2021set"). Reachability techniques are usually applied during the runtime of a system because safety cannot be guranteed ahead of time. Recent work have focused on speeding up the computation of reachable sets by using different set-represtations and by using heurisitcs to reduce the number of steps. Tools like SpaceEx @frehse2011spaceex, Flow\* @chen2013flow, DryVR @fan2017dryvr and PHAVer @frehse2005phaver are all based on the idea of computing reachable sets. They all differ in the specification language of the model and the most recent tool DryVR does not require an explicit model of the system. DryVR makes use of recent advances in learning methods and can be used to verify black box systems by using traces of a simulated system.

Theorem proving on the other hand is a offline technique that is based on finding invariants of a system to prove that a system satisfies a safety specification. The advatange of theorem proving is that safety of a system can be proven for an infinite time horizon @KeYmaera. However, theorem proving requires a high level of expertise and is limited to small systems. Platzer et al. have developed a tool called KeYmera X @KeYmaera that makes use of differential dynamic logic to specify hybrid systems and prove safety properties. The tool makes use of Mathematicas reasoning engine to automate parts of the safety proofs. One issue with offline theorem proving is that the real system might not exhibit the same behavior as the model used in the proof. In a follow up work, Mitsch and Platzer developed a tool called ModelPlex @mitsch2016modelplex which generates a runtime monitor of the system to detect complience with the model.

While there are works that focus on the use of either reachability analysis or theorem proving, there are no works directly comparing the two methods in terms of feasability on a real world system. In this work, we use a benchmark problem of a 2D quadrotor UAV following a trajectory inside a square from Safe-control-gym @yuan2021safe. We implement a model predictive controller for the quadrotor and use both KeYmera X and SpaceEx to verify the safety of the system. We compare the results of the two methods and discuss the advantages and disadvantages of each method.

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




