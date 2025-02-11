@testset "precondition" begin
    A = [2..4 -2..1; -1..2 2..4]
    b = [-2..2, -2..2]

    np = NoPrecondition()
    idp = InverseDiagonalMidpoint()
    imp = InverseMidpoint()

    A1, b1 = np(A, b)
    @test all(isguaranteed.(A1)) && all(isguaranteed.(b1))
    @test isequal_interval(A1, A) && isequal_interval(b1, b)

    A2, b2 = idp(A, b)
    @test all(isguaranteed.(A2)) && all(isguaranteed.(b2))
    Acorrect = [2/3..4/3 -2/3..1/3; -1/3..2/3 2/3..4/3]
    bcorrect = [-2/3..2/3, -2/3..2/3]
    @test all(interval_isapprox.(A2, Acorrect)) && all(interval_isapprox.(b2, bcorrect))

    A3, b3 = imp(A, b)
    @test all(isguaranteed.(A3)) && all(isguaranteed.(b3))
    Acorrect = [22/37..52/37 -20/37..20/37;-20/37..20/37 22/37..52/37]
    bcorrect = [-28/37..28/37, -28/37..28/37]
    @test all(interval_isapprox.(A3, Acorrect)) && all(interval_isapprox.(b3, bcorrect))
end
