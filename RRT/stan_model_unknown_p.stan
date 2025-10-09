
data {
  int<lower=0> N;                 // total respondents
  int<lower=0, upper=N> y_yes;    // observed YES count

  // Prior for theta (true prevalence)
  real<lower=0> alpha;
  real<lower=0> beta;

  // Prior for p_forced (forced-YES probability)
  real<lower=0> a_forced;
  real<lower=0> b_forced;
}

parameters {
  real<lower=0, upper=1> theta;      // true smoking prevalence
  real<lower=0, upper=1> p_forced;   // forced-YES probability (unknown)
}

transformed parameters {
  real<lower=0, upper=1> q;          // Pr(YES observed)
  q = p_forced + (1.0 - p_forced) * theta;
}

model {
  // Priors
  theta    ~ beta(alpha, beta);
  p_forced ~ beta(a_forced, b_forced);

  // Likelihood
  y_yes ~ binomial(N, q);
}

generated quantities {
  // Posterior predictive replicate
  int y_rep = binomial_rng(N, q);

  // Invert q -> theta via algebra (for diagnostics)
  real<lower=0, upper=1> theta_via_q;
  theta_via_q = fmin(fmax((q - p_forced) / (1.0 - p_forced), 0), 1);
}
