import csv

#create empty dictionary to use later
dictx = {}

#create list with keys to be used for dictionary and for looping
field_names = ["first name", "last name", "job title", "company"]

for i in field_names:
    dictx[i] = input("Please enter your {}: ".format(i))


# open the file in the write mode, in this example this will only work if the file already exists. Possible to write it in a way that it checks if it already exits.
with open('cloud-6-repo-MJLippai/08_Python_01/csv/dict.csv', 'a', newline='') as f:
    # create the csv writer
    writer = csv.DictWriter(f, fieldnames = field_names)

    # write a row to the csv file
    writer.writerow(dictx)