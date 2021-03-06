
using IntervalConstraintProgramming
using ValidatedNumerics

using FactCheck


facts("Utilities") do
    @fact IntervalConstraintProgramming.unify_variables([:a, :c], [:c, :b]) -->
        ([:a,:b,:c], [1,3], [3,2], [1,0,2], [0,2,1])
end

facts("Separators") do
    II = -100..100
    X = IntervalBox(II, II)
    S = @constraint x^2 + y^2 <= 1

    inner, outer = S(X)
    @fact inner --> (-1..1, -1..1)
    @fact outer --> (II, II)

    X = IntervalBox(-∞..∞, -∞..∞)
    inner, outer = S(X)
    @fact inner --> (-1..1, -1..1)
    @fact outer --> (-∞..∞, -∞..∞)
end

facts("setinverse") do
    S1a = @constraint x > 0
    S1b = @constraint y > 0

    S1 = S1a ∩ S1b
    paving = setinverse(S1, IntervalBox(-3..3, -3..3), 0.1)
    @fact paving.inner --> [IntervalBox(1.5..3, 0..3), IntervalBox(0..1.5, 0..3)]
    @fact isempty(paving.boundary) --> true

    S2 = S1a ∪ S1b
    paving = setinverse(S2, IntervalBox(-3..3, -3..3), 0.1)
    @fact paving.inner --> [IntervalBox(-3..0, 0..3), IntervalBox(0..3, -3..3)]
    @fact isempty(paving.boundary) --> true


    S3 = @constraint x^2 + y^2 <= 1
    X = IntervalBox(-Inf..Inf, -Inf..Inf)
    paving = setinverse(S3, X, 1)

    @fact paving.inner --> [IntervalBox(Interval(0.0, 0.5), Interval(0.0, 0.8660254037844386)),
                    IntervalBox(Interval(0.0, 0.5), Interval(-0.8660254037844386, 0.0)),
                    IntervalBox(Interval(-0.5, 0.0), Interval(0.0, 0.8660254037844386)),
                    IntervalBox(Interval(-0.5, 0.0), Interval(-0.8660254037844386, 0.0))]

    @fact paving.boundary --> [ IntervalBox(Interval(0.5, 1.0), Interval(0.0, 0.8660254037844387)),
                        IntervalBox(Interval(0.0, 0.5), Interval(0.8660254037844386, 1.0)),
                        IntervalBox(Interval(0.5, 1.0), Interval(-0.8660254037844387, 0.0)),
                        IntervalBox(Interval(0.0, 0.5), Interval(-1.0, -0.8660254037844386)),
                        IntervalBox(Interval(-0.5, 0.0), Interval(0.8660254037844386, 1.0)),
                        IntervalBox(Interval(-1.0, -0.5), Interval(0.0, 0.8660254037844387)),
                        IntervalBox(Interval(-0.5, 0.0), Interval(-1.0, -0.8660254037844386)),
                        IntervalBox(Interval(-1.0, -0.5), Interval(-0.8660254037844387, 0.0))]
end

facts("Volume") do
    x = 3..5
    @fact Vol(x).bounds --> 2

    V = Vol(IntervalBox(-1..1.5, 2..3.5))
    @fact typeof(V) --> IntervalConstraintProgramming.Vol{2, Float64}
    @fact V.bounds --> 3.75

end
