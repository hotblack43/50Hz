PRO getstriketime,file,tim
print,file
pos=strpos(file,'24')
tim=double(strmid(file,pos,16))
caldat,tim,mm,dd,yy,hh,mi,se
print,'Strike at UTC ',mm,dd,yy,hh,mi,se
return
end

files=file_search('OUT/blixt*',count=n)
striketimes=[]
for i=0,n-1,1 do begin
data=get_data(files(i))
getstriketime,files(i),tim
striketimes=[striketimes,tim]
plot,data
print,(max(data)-min(data))/robust_sigma(data)
endfor
end
