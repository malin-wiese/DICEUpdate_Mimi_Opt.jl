# Model commentary for DICE

## History

The DICE model was developed by William Nordhaus [Nordhaus1992](@cite).

## Modelling approach

The DICE model is based on a neoclassical economic growth model, combined with a carbon cycle and climate module [Nordhaus2012](@cite). This means that the world economic output (GDP) is calculated as a function of accumulated capital and the labour force, in combination with technological progress. In every time step (every 5 years), GDP is calculated and both climate damages and mitigation costs are subtracted. Climate damages depend on the amount of global atmospheric warming, which is calculated within the climate module based on previous CO$_2$ emissions. Mitigation costs, on the other hand, depend on technological progress and on the level of mitigation that is chosen at every time step.

Importantly, the DICE model is not purely descriptive, as there are two decisions to be taken at every time step. First, the decision-maker—which is generally referred to as the _social planner_—, chooses how much of current output should be spent on investments and how much should be consumed. Invested output will increase the global capital stock and hence lead to higher GDP, whereas consumed output will increase current global welfare. Second, the social planner chooses how much of the CO$_2$ emissions associated with the given level of economic production will be mitigated, with mitigation costs acting at the expense of current consumption of investment.

But how are these two decisions taken by the model? The DICE model is an optimisation IAM, which means that both the savings rate (amount of economic output being invested rather than consumed) and the mitigation rate (amount of CO$_2$ emissions reduction) are chosen based on a welfare optimisation. In welfare economics, this means that there is a _social welfare function_ which indicates the preferences of the social planer. This social welfare function is mathematically optimised. It is the discounted sum of utilities throughout the whole time horizon of the model. Utilities, on the other hand, are a function of each period's consumption. Discounted means that future consumption contributes less to welfare, for two reasons: first, future consumption is valued less than current consumption because the future is assumed to be richer in general; and second, future utility is valued less than current utility purely because it is further away (see [Criticism](@ref)).

## System boundaries

The DICE model is a single-region model. That means that the whole world produces and consumes a single good. As a consequence, the DICE model is not able to represent distributive aspects, e.g. income inequalities or inequalities in CO$_2$ emissions.

Temporally, it extends from the present (in the current model version taken to be 2015) to the far-away future of 2500. Importantly, the long time horizon is not chosen because of some underlying assumption that centennial projections of socioeconomic variables are accurate or reliable. Rather, the optimised results of numerical models like the DICE are sensitive to the cut-off time. For instance, if the model ends in 2500, the hypothetical social planner will stop investing some time before 2500 and see to consuming everything before the end of the model world. By pushing this inevitable but unplausible behaviour far into the future, modellers make sure that these effects don't distort results within the time frame that we are actually interested in.

As the DICE model only features a single good, it also has no concept of different economic sectors. Thereby, the model is blind to whether a certain mitigation effort happens within, say, the energy or the transport sector. The reduction of CO$_2$ emissions is governed by a single marginal abatement curve (MAC), relating a certain emissions cut to a mitigation cost value.

Similary, the DICE model does not explicitly resolve non-market goods.

## Ethics

- specific welfare criterion
- model structure ()
- projections (growth, population, technological progress, ...)?

## Policy

## Expectations

## References

```@bibliography
Pages = ["commentary.md"]
Canonical = false
```