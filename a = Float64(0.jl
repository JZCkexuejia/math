a = Float64(0.0)
b = Float64(1.0)
n = Int(1345)
step = (b - a) / Float64(n);

# Method I:  \tilde{x}
# with error accumulation
x_t = zeros(Float64, n+1)
x_t[1] = a
for i in 1:n
    x_t[i+1] = x_t[i] + step
end

# Method II: \hat{x}
# without error accumulation
x_h = zeros(Float64, n+1)
x_h[1] = a;
for i in 1:n
    x_h[i+1] = x_h[1] + i * step
end

# Reference solution with `BigFloat`
x_exact = BigFloat.(collect(0:n)) ./ BigFloat(n)

# Absolute error
err_xt = abs.(x_t[2:end-1]-x_exact[2:end-1])  # Method I: \tilde{x}
err_xh = abs.(x_h[2:end-1]-x_exact[2:end-1])  # Method II: \hat{x}

# Relative error
re_err_xt = abs.(x_t[2:end-1]-x_exact[2:end-1]) ./ x_exact[2:end-1]  # Method I: \tilde{x}
re_err_xh = abs.(x_h[2:end-1]-x_exact[2:end-1]) ./ x_exact[2:end-1]  # Method II: \hat{x}

# Postprocess
using Plots

# Absolute error
plot( collect(2:n), err_xt, linestyle=:dash,
        yscale=:log10, lw=1.5, seriescolor=:red,
        label="absolute error of method I",
        gridlinewidth=1)
plot!(collect(2:n), err_xh, linestyle=:solid,
        yscale=:log10, lw=1, seriescolor=:black,
        label="absolute error of method II",
        ylimits=(1e-20,1e-12), legend=:topleft)
xlabel!("Element number")
ylabel!("Relative error")
savefig("absolute_error.png")

# Relative error
plot( collect(2:n), re_err_xt, linestyle=:dash,
        yscale=:log10, lw=1.5, seriescolor=:red,
        label="relative error of method I",
        gridlinewidth=1)
plot!(collect(2:n), re_err_xh, linestyle=:solid,
        yscale=:log10, lw=1, seriescolor=:black,
        label="relative error of method II",
        ylimits=(1e-20,1e-12), legend=:topleft)
xlabel!("Element number")
ylabel!("Relative error")
savefig("relative_error.png")