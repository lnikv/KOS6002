
data {
  int<lower=0> N;                 // total respondents
  int<lower=0, upper=N> y_yes;    // observed YES count
  real<lower=0, upper=1> p_forced;// forced-YES probability (e.g., 0.5)
  real<lower=0> alpha;            // Beta prior alpha
  real<lower=0> beta;             // Beta prior beta
}
parameters {
  real<lower=0, upper=1> theta;   // true prevalence
}
transformed parameters {
  real<lower=0, upper=1> q;       // Pr(YES observed)
  q = p_forced + (1.0 - p_forced) * theta;
}
model {
  theta ~ beta(alpha, beta);
  y_yes ~ binomial(N, q);
}
generated quantities {
  int y_rep = binomial_rng(N, q);
  real<lower=0, upper=1> theta_via_q;
  theta_via_q = fmin(fmax((q - p_forced) / (1.0 - p_forced), 0), 1);
}
