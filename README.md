# nonnest2

nonnest2 provides functionality for comparing non-nested models' fit and distinguishability, relying on theory from Vuong (1989).  The authors acknowledge support from NSF grant SES-1061334.  The contents of this package are those of the authors and do not reflect the views of the National Science Foundation.

The package is intended to work automatically for models of many classes, including `lavaan`, `mirt`, and `glm`. It can also be applied to models of new, unseen classes, so long as the user provides functions to compute the model's casewise log-likelihoods and casewise first derivatives. A notable example is the [*merDeriv* package](https://github.com/nctingwang/merDeriv), which provides those functions for many models estimated via *lme4*.


# Example

Consider the two factor analysis models below, estimated in `lavaan`. The models are not nested due to `x4` and `x7`.

```r
library("lavaan")

m1 <- ' visual  =~ x1 + x2 + x3 + x4
        textual =~ x4 + x5 + x6
        speed   =~ x7 + x8 + x9 '
fit1 <- cfa(m1, data=HolzingerSwineford1939)

m2 <- ' visual  =~ x1 + x2 + x3
        textual =~ x4 + x5 + x6 + x7
        speed   =~ x7 + x8 + x9 '
fit2 <- cfa(m2, data=HolzingerSwineford1939)
```

We can use *nonnest2* to compare the models via Vuong tests and to obtain interval estimates of differences in the models' AIC and BIC values.

```r
vuongtest(fit1, fit2)
icci(fit1, fit2)
```
