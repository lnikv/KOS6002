
data {
  int<lower=0> N;                           // number of trials
  int<lower=0, upper=N> y;                  // number of "YES" responses
  real<lower=0, upper=1> p_yes;             // forced-YES probability (known)
  real<lower=0> alpha;                      // Beta prior hyperparameter
  real<lower=0> beta;                       // Beta prior hyperparameter
}

parameters {
  real<lower=0, upper=1> theta;             // true prevalence
}

transformed parameters {
  real<lower=0, upper=1> q;                 // effective YES probability
  q = p_yes + (1 - p_yes) * theta;
}

model {
  // Prior
  theta ~ beta(alpha, beta);

  // Likelihood
  y ~ binomial(N, q);
}

generated quantities {
  // Posterior predictive draw
  int y_rep = binomial_rng(N, q);

  // Optional: invert q to "recover" theta via the randomized-response formula.
  // This equals theta in this model, but it's handy for clarity/debugging.
  real<lower=0, upper=1> theta_via_q = (q - p_yes) / (1 - p_yes);
}
