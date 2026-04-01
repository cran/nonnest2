context("DiscreteClass mirt::extract.mirt path")

test_that("DiscreteClass uses mirt::extract.mirt for npar in vuongtest", {
  if (isTRUE(require("mirt"))) {
    data <- expand.table(LSAT7)
    mod1 <- mdirt(data, 2, SE = TRUE, SE.type = "Oakes")
    mod2 <- mdirt(data, 3, SE = TRUE, SE.type = "Oakes")

    ## expected npar from mirt::extract.mirt (the correct path)
    npar1 <- mirt::extract.mirt(mod1, "nest")
    npar2 <- mirt::extract.mirt(mod2, "nest")

    ## npar from length(coef()) (the wrong path if DiscreteClass is missing)
    npar1_wrong <- length(coef(mod1))
    npar2_wrong <- length(coef(mod2))

    ## sanity: these should differ, otherwise the test is trivial
    expect_false(npar1 == npar1_wrong && npar2 == npar2_wrong,
                 info = "extract.mirt('nest') and length(coef()) should differ for DiscreteClass")

    ## run vuongtest without adjustment (baseline)
    vt_none <- vuongtest(mod1, mod2, adj = "none")
    lr_none <- sum(llcont(mod1) - llcont(mod2), na.rm = TRUE)

    ## run vuongtest with AIC adjustment
    vt_aic <- vuongtest(mod1, mod2, adj = "aic")
    expect_s3_class(vt_aic, "vuongtest")

    ## run vuongtest with BIC adjustment
    vt_bic <- vuongtest(mod1, mod2, adj = "bic")
    expect_s3_class(vt_bic, "vuongtest")

    ## verify AIC-adjusted LR uses correct npar (from extract.mirt)
    n <- length(llcont(mod1))
    omega2 <- (n - 1) / n * var(llcont(mod1) - llcont(mod2), na.rm = TRUE)
    lr_aic_expected <- lr_none - (npar1 - npar2)
    teststat_aic_expected <- (1 / sqrt(n)) * lr_aic_expected / sqrt(omega2)
    expect_equal(vt_aic$LRTstat, teststat_aic_expected)

    ## verify BIC-adjusted LR uses correct npar (from extract.mirt)
    lr_bic_expected <- lr_none - (npar1 - npar2) * log(n) / 2
    teststat_bic_expected <- (1 / sqrt(n)) * lr_bic_expected / sqrt(omega2)
    expect_equal(vt_bic$LRTstat, teststat_bic_expected)
  }
})

test_that("DiscreteClass uses mirt::extract.mirt for AIC/BIC in icci", {
  if (isTRUE(require("mirt"))) {
    data <- expand.table(LSAT7)
    mod1 <- mdirt(data, 2, SE = TRUE, SE.type = "Oakes")
    mod2 <- mdirt(data, 3, SE = TRUE, SE.type = "Oakes")

    ## expected AIC/BIC from mirt::extract.mirt (the correct path)
    aic1 <- mirt::extract.mirt(mod1, "AIC")
    aic2 <- mirt::extract.mirt(mod2, "AIC")
    bic1 <- mirt::extract.mirt(mod1, "BIC")
    bic2 <- mirt::extract.mirt(mod2, "BIC")

    ic <- icci(mod1, mod2)
    expect_s3_class(ic, "icci")

    ## verify icci used extract.mirt values, not generic AIC()
    expect_equal(ic$AIC$AIC1, aic1)
    expect_equal(ic$AIC$AIC2, aic2)
    expect_equal(ic$BIC$BIC1, bic1)
    expect_equal(ic$BIC$BIC2, bic2)
  }
})
