
-- problem 5.11 automatic cost calculation
quad_min a b c = (-b - sqrt(b^2 - 4*a*c))/2*a

cost x = let x'=abs(100*x) in 102 - ceiling(quad_min (-1) 1 (10100 - 2*x'))
y_min x = let x'=abs(100*x) in quad_min (-1) 1 (10100 - 2*x')

-- cost 4.71
-- cost (-6.97)
-- cost 8.59

