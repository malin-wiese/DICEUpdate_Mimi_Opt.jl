# Model commentary for DICE

### What is a model commentary?

## History of DICE

The DICE model was developed by William Nordhaus [Nordhaus1992](@cite). See also Nobel Prize scientific background

## Modelling approach

The DICE model is based on a neoclassical economic growth model, combined with a carbon cycle and climate module [Nordhaus2012](@cite). This means that the world economic output (GDP) is calculated as a function of accumulated capital and the labour force, in combination with technological progress. In every time step (every 5 years), GDP is calculated and both climate damages and mitigation costs are subtracted. Climate damages depend on the amount of global atmospheric warming, which is calculated within the climate module based on previous CO$_2$ emissions. Mitigation costs, on the other hand, depend on technological progress and on the level of mitigation that is chosen at every time step.

Importantly, the DICE model is not purely descriptive, as there are two decisions to be taken at every time step. First, the decision-maker—which is generally referred to as the _social planner_—, chooses how much of current output should be spent on investments and how much should be consumed. Invested output will increase the global capital stock and hence lead to higher GDP, whereas consumed output will increase current global welfare. Second, the social planner chooses how much of the CO$_2$ emissions associated with the given level of economic production will be mitigated, with mitigation costs acting at the expense of current consumption of investment.

But how are these two decisions taken by the model? The DICE model is an optimisation IAM, which means that both the savings rate (amount of economic output being invested rather than consumed) and the mitigation rate (amount of CO$_2$ emissions reduction) are chosen based on a welfare optimisation. In welfare economics, this means that there is a _social welfare function_ which indicates the preferences of the social planer. This social welfare function is mathematically optimised. It is the discounted sum of utilities throughout the whole time horizon of the model. Utilities, on the other hand, are a function of each period's consumption. Discounted means that future consumption contributes less to welfare, for two reasons: first, future consumption is valued less than current consumption because the future is assumed to be richer in general; and second, future utility is valued less than current utility purely because it is further away (see [Criticism](@ref)).

## System boundaries

The DICE model is a single-region model. That means that the whole world produces and consumes a single good. As a consequence, the DICE model is not able to represent distributive aspects, e.g. income inequalities or inequalities in CO$_2$ emissions.

Temporally, it extends from the present (in the current model version taken to be 2015) to the far-away future of 2500. Importantly, the long time horizon is not chosen because of some underlying assumption that centennial projections of socioeconomic variables are accurate or reliable. Rather, the optimised results of numerical models like the DICE are sensitive to the cut-off time. For instance, if the model ends in 2500, the hypothetical social planner will stop investing some time before 2500 and see to consuming everything before the end of the model world. By pushing this inevitable but unplausible behaviour far into the future, modellers make sure that these effects don't distort results within the time frame that we are actually interested in.

As the DICE model only features a single good, it also has no concept of different economic sectors. Thereby, the model is blind to whether a certain mitigation effort happens within, say, the energy or the transport sector. The reduction of CO$_2$ emissions is governed by a single marginal abatement curve (MAC), relating a certain emissions cut to a mitigation cost value.

Similarly, the DICE model does not explicitly resolve non-market goods. That is, the capital stock only consists of "manufactured capital", which can be used to produce goods and services that are sold on markets. There is no concept of "natural capital", which would be needed to produce non-market goods like clean air or biodiversity. Also the role of natural capital in producing market goods is not represented in the DICE model (see [Extensions](@ref)).

- deterministic formulation not allowing for risk and uncertainty or catastrophic outcomes?

## Ethical issues

Being a welfare-optimising economic growth model, the DICE model is based on a range of normative choices. 

First of all, the assumed social welfare function is based on the consequentialist ethical framework of discounted utilitarianism. This framework requires explicit parameters choices of the _rate of pure time preference_ and the _elasticity of intertemporal substitution_ (also called intertemporal inequality aversion), which have to be ethically justified. Implicitly, this welfare framework also assumes that the social planner is indifferent to _risks and uncertainty_, as the model runs entirely deterministically. Further, any inequalities within a certain time period do not influence the welfare assessment, as they are all aggregated into a single consumption value. This means that the DICE model is not able to represent _distributive aspects_ at all (see [System boundaries](@ref)) — in fact, it deliberately ignores both inequalities between and within countries.

Second, there are more implicitly normative aspects in the setting of [System boundaries](@ref). For example, which kinds of climate-change-induced damages are included into the welfare assessment? Non-market goods are excluded in the DICE model, such that biodiversity loss is not considered. The same goes for many other climate change damages. Despite this being a consequence of the difficulty of quantifying these damage channels, and not necessarily a deliberate normative choice to exclude them, it still amounts to a normatively relevant modelling choice.

Third, the DICE model is based on a range of assumptions and projections about the future development of important socioeconomic variables. These include economic productivity, global population, technological progress in low-carbon technologies, among others. Again, these projections are not explicitly normative and based on best-guess evidence from other sources. However, they can still implicitly contain normative assumptions. For example, the required future levels of GDP are politically debated and this political debate is sidelined by the DICE model's reliance on GDP projections. Similarly, the choice of modelling technological progress in low-carbon technologies as exogenous, i.e. developing with a fixed rate independent of climate policy, is normative in that it restricts the range of possible mitigation pathways at the social planner's disposal (see [Extensions](@ref)).

- assumed rationality of social planner?

## Policy impact

William Nordhaus describes the most important policy implications of the DICE model as follows (see [Nordhaus2012](@citet), p. 1095):

>- Making consistent projections, i.e. ones that have consistent inputs and outputs of the different components of the system (so that the GDP projections are consistent with the emissions projections).
>- Calculating the impacts of alternative assumptions on important variables such as output, emissions, temperature change and impacts.
>- Tracing through the effects of alternative policies on all variables in a consistent manner, as well as estimating the costs and benefits of alternative strategies.
>- Estimating the uncertainties associated with alternative variables and strategies.
>- Calculating the effects of reducing uncertainties about key parameters or variables, as well as estimating the value of research and new technologies.

In a paper that discusses the policy impact of William Nordhaus, [Aldy2020](@citet) differentiate between (1) "direct participation in the policy world", (2) "directly influencing public policies", and (3) "indirectly informing public policy". According to the authors, the main impact on climate policy was through (3), by subtly influencing the discourse around policy stringency and options.

The DICE model shaped the climate debate by framing climate policy as a trade-off between economic growth and climate change mitigation.

As part of the direct influence on climate policy (2), the DICE model has been used to estimate social cost of carbon (SCC) figures to be used for assessing the climate impact of policy proposals.

- see [Aldy2020](@citet)
- quantifying an externality arising from a market failure &rarr; implicit policy recommendation to correct this market failure by internalising externality (e.g. through carbon pricing)
- shaping the policy discourse: focus on market mechanisms to correct for market failure
- implicit: focus on economic growth as a policy goal
- implicit: globally aggregated perspective puts focus on globally agreed solution without emphasis on distributional aspects and global inequalities
- guideline for international climate negotiations (e.g. 2°C target)
- scenario analysis
- early recommendation: to invest in conventional capital and only later in abatement (see Aldy and Stevens), keep the energy system as it is
- quantifying the costs of climate change &rarr; implicit policy recommendation to avoid these costs (e.g. through mitigation)
- estimating social cost of carbon: guideline for carbon pricing and regulatory input (e.g. in US or Germany)

The DICE model is 

## Expectations

"When we speak about optimal policy below, we thus refer to using the model in that way, namely to quantify how (different) normative assumptions shape variables like carbon taxes, temperature limits, and emission paths." [Nobel2018](@citep)

## References

```@bibliography
Pages = ["commentary.md"]
Canonical = false
```