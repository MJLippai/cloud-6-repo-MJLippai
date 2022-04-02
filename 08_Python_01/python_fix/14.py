'''
The output should be:
True
'''
# this function doesn't really do anything but to not remove it everywhere, I've left it in place.
def rtn(x):
	return(x)

foo = rtn(3)

if foo < rtn(4):  #Changed > to <. Basically comes to out to if 3 is smaller than 4.
	print(True)
else:
	print(False)

# achieves same thing as above print(foo < rtn(4))