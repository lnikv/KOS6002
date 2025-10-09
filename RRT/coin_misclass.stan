
data {
  int<lower=0> N;
  int<lower=0, upper=N> r;
  real<lower=0, upper=0.5> y;  // set to 0.4
  real<lower=0> alpha;
  real<lower=0> beta;
}
parameters { real<lower=0, upper=1> theta; }
transformed parameters {
  real<lower=0, upper=1> q;
  q = y + (1 - 2*y) * theta;
}
model {
  theta ~ beta(alpha, beta);
  r ~ binomial(N, q);
}
generated quantities {
  int r_rep = binomial_rng(N, q);
  real<lower=0, upper=1> theta_via_q = (q - y) / (1 - 2*y);
}
