import csv
from os import error, write

file = open("IMDB.csv")
headers = next(file).split(",")
file.close


file = open("IMDB.csv")
dict_file = csv.DictReader(file)
selected_movies= []
genre = ["Action","Comedy","Biography","Adventure","Drama",]
new_file = open("Gruped_Genre.csv", "w")
top = ""
i = 0
for l,head in enumerate(headers):
    if l != 5 and l != 6 and l != len(headers) - 1:
        top = top + head + ","
    elif l == len(headers) - 1:
        top = top + head
new_file.write(top)
i = j = 0
while(i < 5):
    for row in dict_file:
        if j < 10 and row[headers[8]][0] == "$" and row[headers[7]] != "NA" and (row[headers[1]] not in selected_movies) and (row[headers[4]] == genre[i] or row[headers[5]] == genre[i] or row[headers[6]] == genre[i]):
            movie = row[headers[1]]
            #print(movie)
            #print(row[headers[3]])
            t = ""
            error = False
            for k, key in enumerate(row.values()):
                if key == "":
                    error = True
                    continue
                if k == 4:
                    t = t + '"' + genre[i] + '"' + ","
                elif k != 5 and k != 6:
                    t = t + '"' + key + '"' + ","
            if error:
                continue    
            #print(j)
            new_file.write(t+"\n")
            selected_movies.append(movie)
            j += 1
        if j==10:
            break
    file.close()
    file = open("IMDB.csv")
    dict_file = csv.DictReader(file)
    j=0
    i+=1

file.close()
new_file.close()

file = open("Gruped_Genre.csv")
dict_file = csv.DictReader(file)
budgets = {}
ratings = {}
for row in dict_file:
    budgets[row[headers[0]]]=(float(row[headers[8]].removeprefix("$").replace(",","") ))
    ratings[row[headers[0]]]=(float(row[headers[2]].replace(",",".")))
new_budgets = {k: v for k, v in sorted(budgets.items(), key=lambda item: item[1])}
new_ratings = {k: v for k, v in sorted(ratings.items(), key=lambda item: item[1])}
print(new_budgets)
means_bud = []
means_rat = []
i = 0
while i < 5:
    sum_bud = 0
    sum_rat = 0
    j = 0
    while j < 10:
        sum_bud = sum_bud + int(list(new_budgets.values())[j+(i*10)])
        sum_rat = sum_rat + float(list(new_ratings.values())[j+(i*10)])
        j += 1
    means_bud.append(sum_bud/10)
    means_rat.append(round(sum_rat/10,1))
    i += 1
print(means_rat)
for i, elem in enumerate(new_budgets):
    new_budgets[elem] = means_bud[int(i/10)]
for i, elem in enumerate(new_ratings):
    new_ratings[elem] = means_rat[int(i/10)]
print(new_budgets)
file.close()

file = open("Gruped_Genre.csv")
dict_file = csv.DictReader(file)
new_file = open("Gruped.csv", "w")

new_file.write(top)
for i, row in enumerate(dict_file):
    t = ""
    for j, key in enumerate(row.values()):
        if j == 6:
            t = t + '"$' + str(new_budgets[list(row.values())[0]]) + '"' + ","
        elif j == 2:
            t = t + '"' + str(new_ratings[list(row.values())[0]]) + '"' + ","
        elif j == len(list(row.values())) - 1:
            continue
        else:
            t = t + '"' + str(key) + '"' + ","
    new_file.write(t+"\n")

file.close()
new_file.close()

