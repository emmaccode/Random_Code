def mcase(x : int):
    match x:
        case 500:
            print("500")

def mcase_cond(x : int):
    l1 = [5, 10, 15]
    l2 = [2, 4, 6]
    match x:
        case n if n in l1:
            print("multiple of 5")
        case n if n in l2:
            print("multiple of 2")
        case _:
            print("Not in l1 or l2")
mcase(500)
mcase_cond(5)
mcase_cond(100)
