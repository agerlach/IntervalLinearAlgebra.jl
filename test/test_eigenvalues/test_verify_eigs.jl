@testset "verify perron frobenius " begin
    A = [1 2;3 4]
    ρ = bound_perron_frobenius_eigenvalue(A)
    @test  (5+sqrt(big(5)))/2 ≤ ρ
end

@testset "verified eigenvalues" begin
    n = 5 # matrix size

    # symmetric case
    ev = sort(randn(n))
    D = Diagonal(ev)
    Q, _ = qr(rand(n, n))
    A = Symmetric(interval.(Matrix(Q)) * interval.(D) * interval.(Matrix(Q')))

    evals, evecs, cert = verify_eigen(A)
    @test all(cert)
    @test all(in_interval.(ev , evals))


    # real eigenvalues case
    P = rand(n, n)
    Pinv, _ = epsilon_inflation(P, Diagonal(ones(n)))
    A = IA.interval.(P) * interval.(D) * Pinv

    evals, evecs, cert = verify_eigen(A)
    @test all(cert)
    @test all(in_interval.(ev , evals))

    # test complex eigenvalues
    ev = sort(rand(Complex{Float64}, n), by = x -> (real(x), imag(x)))
    A = IA.interval.(P) * Matrix(Diagonal(interval.(ev))) * Pinv

    evals, evecs, cert = verify_eigen(A)
    @test all(cert)
    @test all(in_interval.(ev , evals))
end
