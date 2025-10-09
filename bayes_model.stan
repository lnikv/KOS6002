
data {
  // N is the total number of trials (80 + 20 = 100)
  int<lower=0> N; 
  // y is the number of "successes" (80)
  int<lower=0, upper=N> y; 
}

parameters {
  // theta is the parameter we want to sample, constrained between 0 and 1
  real<lower=0, upper=1> theta;
}

transformed parameters {
  // Define the probability of success 'p' based on the relationship 
  // from the likelihood function: p = (1 + theta) / 2
  real<lower=0, upper=1> p = (1.0 + theta) / 2.0;
}

model {
  // 1. PRIOR (Prior(theta) = theta^3 * (1-theta))
  // This is proportional to a Beta(4, 2) distribution 
  // (since Beta(a, b) is proportional to theta^(a-1) * (1-theta)^(b-1))
  target += beta_lpdf(theta | 4, 2);

  // 2. LIKELIHOOD (L(theta) = ((1+theta)/2)^80 * ((1-theta)/2)^20)
  // This is the log probability mass function (lpmf) of a Binomial distribution
  // with 'y' successes out of 'N' trials and success probability 'p'.
  target += binomial_lpmf(y | N, p);

  // Stan automatically combines the log-prior and log-likelihood to sample 
  // from the unnormalized log-posterior distribution.
}
