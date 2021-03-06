##### halo points ≥ 2 NEEDED!!
const θmax = 1.0e20

##### calculate CFL number: c=uΔt/Lx
@inline CFLx(i, j, k, g::Grids, u, ΔT) = @inbounds abs(u[i, j, k] * ΔT / g.Δx)
@inline CFLy(i, j, k, g::Grids, v, ΔT) = @inbounds abs(v[i, j, k] * ΔT / g.Δy)
@inline CFLz(i, j, k, g::Grids, w, ΔT) = @inbounds abs(w[i, j, k] * ΔT / g.Δz)

##### calculate d₀ and d₁
@inline d0(CFL) = @inbounds (2.0 - CFL) * (1.0 - CFL) / 6.0
@inline d1(CFL) = @inbounds (1.0 - CFL * CFL) / 6.0

##### calculate volume transport, unit: m³/s
@inline Trans_x(i, j, k, g::Grids, u) = @inbounds g.Ax * u[i, j, k]
@inline Trans_y(i, j, k, g::Grids, v) = @inbounds g.Ay * v[i, j, k]
@inline Trans_z(i, j, k, g::Grids, w) = @inbounds g.Az * w[i, j, k]

##### calculate θ⁺ and θ⁻
@inline θx⁺(i, j, k, c) = abs(δx⁰(i, j, k, c))*θmax ≤ abs(δx⁻(i, j, k, c)) ?
    copysign(θmax, δx⁻(i, j, k, c)*δx⁰(i, j, k, c)) : δx⁻(i, j, k, c)/δx⁰(i, j, k, c)

@inline θx⁻(i, j, k, c) = abs(δx⁰(i, j, k, c))*θmax ≤ abs(δx⁺(i, j, k, c)) ?
    copysign(θmax, δx⁺(i, j, k, c)*δx⁰(i, j, k, c)) : δx⁺(i, j, k, c)/δx⁰(i, j, k, c)

@inline θy⁺(i, j, k, c) = abs(δy⁰(i, j, k, c))*θmax ≤ abs(δy⁻(i, j, k, c)) ?
    copysign(θmax, δy⁻(i, j, k, c)*δy⁰(i, j, k, c)) : δy⁻(i, j, k, c)/δy⁰(i, j, k, c)

@inline θy⁻(i, j, k, c) = abs(δy⁰(i, j, k, c))*θmax ≤ abs(δy⁺(i, j, k, c)) ?
    copysign(θmax, δy⁺(i, j, k, c)*δy⁰(i, j, k, c)) : δy⁺(i, j, k, c)/δy⁰(i, j, k, c)

@inline θz⁺(i, j, k, c) = abs(δz⁰(i, j, k, c))*θmax ≤ abs(δz⁻(i, j, k, c)) ?
    copysign(θmax, δz⁻(i, j, k, c)*δz⁰(i, j, k, c)) : δz⁻(i, j, k, c)/δz⁰(i, j, k, c)

@inline θz⁻(i, j, k, c) = abs(δz⁰(i, j, k, c))*θmax ≤ abs(δz⁺(i, j, k, c)) ?
    copysign(θmax, δz⁺(i, j, k, c)*δz⁰(i, j, k, c)) : δz⁺(i, j, k, c)/δz⁰(i, j, k, c)

##### calculate Ψ⁺ and Ψ⁻
@inline Ψx⁺(i, j, k, g::Grids, u, c, ΔT) = 
            max(0.0, min(min(1.0, d0(CFLx(i, j, k, g, u, ΔT)) + d1(CFLx(i, j, k, g, u, ΔT)) * θx⁺(i, j, k, c)), 
                         θx⁺(i, j, k, c) * (1.0 - CFLx(i, j, k, g, u, ΔT)) / (CFLx(i, j, k, g, u, ΔT) + 1.0e-20)))

@inline Ψx⁻(i, j, k, g::Grids, u, c, ΔT) = 
            max(0.0, min(min(1.0, d0(CFLx(i, j, k, g, u, ΔT)) + d1(CFLx(i, j, k, g, u, ΔT)) * θx⁻(i, j, k, c)), 
                         θx⁻(i, j, k, c) * (1.0 - CFLx(i, j, k, g, u, ΔT)) / (CFLx(i, j, k, g, u, ΔT) + 1.0e-20)))

@inline Ψy⁺(i, j, k, g::Grids, v, c, ΔT) = 
            max(0.0, min(min(1.0, d0(CFLy(i, j, k, g, v, ΔT)) + d1(CFLy(i, j, k, g, v, ΔT)) * θy⁺(i, j, k, c)), 
                         θy⁺(i, j, k, c) * (1.0 - CFLy(i, j, k, g, v, ΔT)) / (CFLy(i, j, k, g, v, ΔT) + 1.0e-20)))

@inline Ψy⁻(i, j, k, g::Grids, v, c, ΔT) =
            max(0.0, min(min(1.0, d0(CFLy(i, j, k, g, v, ΔT)) + d1(CFLy(i, j, k, g, v, ΔT)) * θy⁻(i, j, k, c)), 
                         θy⁻(i, j, k, c) * (1.0 - CFLy(i, j, k, g, v, ΔT)) / (CFLy(i, j, k, g, v, ΔT) + 1.0e-20)))

@inline Ψz⁺(i, j, k, g::Grids, w, c, ΔT) = 
            max(0.0, min(min(1.0, d0(CFLz(i, j, k, g, w, ΔT)) + d1(CFLz(i, j, k, g, w, ΔT)) * θz⁺(i, j, k, c)), 
                         θz⁺(i, j, k, c) * (1.0 - CFLz(i, j, k, g, w, ΔT)) / (CFLz(i, j, k, g, w, ΔT) + 1.0e-20)))

@inline Ψz⁻(i, j, k, g::Grids, w, c, ΔT) = 
            max(0.0, min(min(1.0, d0(CFLz(i, j, k, g, w, ΔT)) + d1(CFLz(i, j, k, g, w, ΔT)) * θz⁻(i, j, k, c)), 
                         θz⁻(i, j, k, c) * (1.0 - CFLz(i, j, k, g, w, ΔT)) / (CFLz(i, j, k, g, w, ΔT) + 1.0e-20)))

##### advection flux
@inline function adv_flux_x(i, j, k, g::Grids, u, c, ΔT)
    0.5 * (Trans_x(i, j, k, g, u) + abs(Trans_x(i, j, k, g, u))) * (c[i-1, j, k] + Ψx⁺(i, j, k, g, u, c, ΔT) * δx⁰(i, j, k, c)) +
    0.5 * (Trans_x(i, j, k, g, u) - abs(Trans_x(i, j, k, g, u))) * (c[i,   j, k] - Ψx⁻(i, j, k, g, u, c, ΔT) * δx⁰(i, j, k, c))
end
@inline adv_flux_y(i, j, k, g::Grids, v, c, ΔT) =
    0.5 * (Trans_y(i, j, k, g, v) + abs(Trans_y(i, j, k, g, v))) * (c[i, j-1, k] + Ψy⁺(i, j, k, g, v, c, ΔT) * δy⁰(i, j, k, c)) +
    0.5 * (Trans_y(i, j, k, g, v) - abs(Trans_y(i, j, k, g, v))) * (c[i, j,   k] - Ψy⁻(i, j, k, g, v, c, ΔT) * δy⁰(i, j, k, c))

@inline adv_flux_z(i, j, k, g::Grids, w, c, ΔT) =
    0.5 * (Trans_z(i, j, k, g, w) + abs(Trans_z(i, j, k, g, w))) * (c[i, j, k-1] + Ψz⁺(i, j, k, g, w, c, ΔT) * δz⁰(i, j, k, c)) +
    0.5 * (Trans_z(i, j, k, g, w) - abs(Trans_z(i, j, k, g, w))) * (c[i, j,   k] - Ψz⁻(i, j, k, g, w, c, ΔT) * δz⁰(i, j, k, c))
