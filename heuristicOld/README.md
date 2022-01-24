
## Heuristics

This folder contain the following implementations:

- **h0.lp** : Optimization of a similarity metric (via **#minimize** or **#maximize**)

- **h1.lp** : Heuristic on order of synthesis steps (via modifier **level**)

- **h2.1.lp** : Heuristic preferring equal decisions (v1) (via modifier **true**)

- **h2.2.lp** : Heuristic avoiding unequal decisions (v1) (via modifier **false**)

- **h3.1.lp** : Heuristic preferring equal decisions (v2) (via modifier **true**)

- **h3.2.lp** : Heuristic avoiding unequal decisions (v2) (via modifier **false**)

- **h4.lp** : Preventing unequal decisions (via **integrity constraints**)

- **h5.lp** : Heuristic preferring equal decisions (via **init/factor**)

  

More test cases which could be considered:

- Optimization of a similarity metric in background theory (via **#preference**)

- Compare usefulness of heuristics for the different synthesis steps


## Analysis

This folder contain the following implementations:

- **compareImplementation.lp** : Analysis on the similarities and differences of the specifications

- **compareSpecification.lp** : Analysis on the similarities and differences of the implementations
  

**#TODO** h0.lp, h3.2.lp, h4.lp, background theory

