import cmdstanpy
import numpy as np
import matplotlib.pyplot as plt
import os

# --- 1. Define Data and Model ---

# Data corresponding to the likelihood function:
# L(theta) = ((1+theta)/2)^80 * ((1-theta)/2)^20
stan_data = {
    'N': 100,  # Total trials: 80 + 20
    'y': 80    # Successes
}

stan_file = 'bayesian_model.stan'
model_name = os.path.splitext(stan_file)[0]

# --- 2. Compile and Instantiate Model ---
try:
    print(f"Compiling Stan model: {stan_file}...")
    model = cmdstanpy.CmdStanModel(stan_file=stan_file)
    print("Model compiled successfully.")
except Exception as e:
    print(f"Error compiling Stan model: {e}")
    print("Please ensure CmdStan is installed and configured correctly.")
    exit()

# --- 3. Run MCMC Sampling (HMC) ---
try:
    print("Starting HMC sampling...")
    fit = model.sample(
        data=stan_data,
        chains=4,          # Run 4 independent Markov chains
        iter_warmup=1000,  # Burn-in period
        iter_sampling=2000, # Number of samples to draw after warmup
        seed=1234          # For reproducibility
    )
    print("Sampling completed.")
except Exception as e:
    print(f"Error during sampling: {e}")
    exit()

# --- 4. Analyze and Plot Results ---

# Extract samples of theta (parameters are stored in an xarray dataset)
theta_samples = fit.stan_variable('theta')

# Flatten all chains into a single array for plotting
all_samples = theta_samples.flatten()

print("\n--- Summary Statistics (from Stan) ---")
print(fit.summary(['theta']))
print(f"Total effective samples (N_eff): {fit.summary(['theta']).loc['theta', 'N_eff']:.0f}")

# Plotting
plt.figure(figsize=(12, 6))

# Subplot 1: Trace Plot (first chain)
plt.subplot(1, 2, 1)
plt.plot(theta_samples[0, :], color='darkred', alpha=0.8, linewidth=1)
plt.title(f'Trace Plot (Chain 1 of 4, {len(theta_samples[0, :])} Samples)')
plt.xlabel('Iteration')
plt.ylabel(r'$\theta$ Value')
plt.grid(True, linestyle='--', alpha=0.6)

# Subplot 2: Posterior Histogram
plt.subplot(1, 2, 2)
# Histogram of all collected samples
plt.hist(
    all_samples, 
    bins=50, 
    density=True, 
    color='cornflowerblue', 
    edgecolor='black', 
    alpha=0.8,
    label='HMC Posterior Samples'
)
plt.title(r'Posterior Distribution of $\theta$ (HMC)')
plt.xlabel(r'$\theta$')
plt.ylabel('Density')
plt.legend()
plt.grid(axis='y', linestyle='--', alpha=0.6)

plt.suptitle(f'Hamiltonian Monte Carlo Sampling using CmdStanPy (Model: {model_name})', fontsize=16)
plt.tight_layout(rect=[0, 0, 1, 0.96])
plt.show()
