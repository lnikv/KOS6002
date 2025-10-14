data {
  int<lower=1> N;                    // number of observations
  int<lower=1> N_students;           // number of students
  int<lower=1> N_items;              // number of items
  int<lower=1> N_traits;             // number of traits
  int<lower=1> N_raters;             // number of raters
  int<lower=2> max_score;            // maximum score (e.g., 5)

  array[N] int<lower=1, upper=N_students> student_idx;  // per-observation indices
  array[N] int<lower=1, upper=N_items>    item_idx;
  array[N] int<lower=1, upper=N_traits>   trait_idx;
  array[N] int<lower=1, upper=N_raters>   rater_idx;
  array[N] int<lower=1, upper=max_score>  score;        // observed category 1..max_score
}

parameters {
  vector[N_students] theta;                           // student abilities
  matrix[N_items,  N_traits] delta;                   // item-by-trait difficulties
  matrix[N_raters, N_traits] rho;                     // rater-by-trait severities
  // thresholds (ordered cutpoints) for each trait × item × rater
  array[N_traits, N_items, N_raters] ordered[max_score-1] tau;
}

model {
  // Priors
  theta ~ normal(0, 1);
  to_vector(delta) ~ normal(0, 1);
  to_vector(rho)   ~ normal(0, 1);
  for (t in 1:N_traits)
    for (i in 1:N_items)
      for (r in 1:N_raters)
        tau[t, i, r] ~ normal(0, 2);

  // Soft identifiability (anchor ability scale around 0)
  sum(theta) ~ normal(0, 0.1);

  // Likelihood (Many-Facet Partial Credit via ordered logistic)
  for (n in 1:N) {
    int s = student_idx[n];
    int i = item_idx[n];
    int t = trait_idx[n];
    int r = rater_idx[n];

    score[n] ~ ordered_logistic(
      theta[s]
      - delta[i, t]
      - rho[r, t],
      tau[t, i, r]
    );
  }
}
