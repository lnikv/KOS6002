
data {
  int<lower=0> N;
  int<lower=0, upper=N> y;
}
parameters {
  real<lower=0, upper=1> theta;
}
transformed parameters {
  real<lower=0, upper=1> p = (1.0 + theta) / 2.0;
}

// Note: 'y' is the observed data, so we may use '~' notation even if the probability model is a discrete PMF.
model {
  theta ~ beta(4, 2);
  y ~ binomial(N, p); 
}
