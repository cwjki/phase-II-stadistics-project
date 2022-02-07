import csv
from os import error, write

file = open("IMDB.csv")
headers = next(file).split(",")
file.close


file = open("IMDB.csv")
dict_file = csv.DictReader(file)
selected_movies= []
genre = ["Romance","Mystery","Action","Comedy","Biography","Adventure","Drama",]
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
while(i < 7):
    for row in dict_file:
        if j < 6 and row[headers[8]][0] == "$" and row[headers[7]] != "NA" and (row[headers[1]] not in selected_movies) and (row[headers[4]] == genre[i] or row[headers[5]] == genre[i] or row[headers[6]] == genre[i]):
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