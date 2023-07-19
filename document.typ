#import "ieee_template.typ": ieee
#let title = "Formally verified stable hovering drone controller"
#let abstract = [
    In recent years, the use of Unmanned Aerial Vehicles (UAVs) has increased significantly in applications such as surveillance, search and rescue, and package delivery. Ensuring savety in close proximity to humans is a major challenge for UAVs. In this paper, we present a formally verified controller for a quadrotor UAV. We use the KeYmera X theorem prover to prove that the controller can maintain a stable hover. Further, we conduct an experimental evaluation of the controller on a real UAV. Our results show that the controller can maintain a stable hover in the presence of disturbances.
]
#let keywords = [
    UAV, Formal verification, KeYmera X, Quadrotor, Hovering
]
#let bibliography_file = "bibliography.bib"
#show: doc => ieee(title, abstract,
 keywords,
 bibliography_file,
doc)
 
= INTRODUCTION
Theorem prover KeYmera X @KeYmaera.   

= RELATED WORK

= Methodology

= Results




