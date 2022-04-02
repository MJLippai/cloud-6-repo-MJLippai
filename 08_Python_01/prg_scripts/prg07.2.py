# create a new list
x = [21, 24, 10, 14, 30]

# first get a range of indexs to work with, then if the number is the last in list, add last number to first. Otherwise just add to next number.

print("My list:",x)
for i in range(len(x)):
    if x[i] == x[-1]:
        print(x[i] + x[0])
    else:
        print(x[i] + x[i+1])
    