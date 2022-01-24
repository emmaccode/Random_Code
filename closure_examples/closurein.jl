function example2(n)
    h = function hello()
        println(n)
    end
    h
end
ourfunc = example2(5)
ourfunc()
