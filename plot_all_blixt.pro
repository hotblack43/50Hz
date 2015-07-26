PRO plotstrikes,striketimes,power
n=n_elements(striketimes)
plot,xstyle=3,ystyle=3,xtitle='Hours since last noon',ytitle='S.D.',title='Sound-card events',24*(striketimes mod 1),power,psym=7
for k=0,n-1,1 do begin
oplot,24.*[striketimes(k) mod 1,striketimes(k) mod 1],[0,power(k)]
endfor
return
end

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
power=[]
w=30
sum=[]
for i=0,n-1,1 do begin
data=get_data(files(i))
idx=where(data eq max(data))
piece=data(idx(0)-w:idx(0)+w)
plot,piece,xtitle='Time [22 mu-secs]',ytitle='Event, and avg (red)'
sum=[[sum],[piece]]
if (i gt 3) then oplot,avg(sum,1),color=fsc_color('red')
getstriketime,files(i),tim
striketimes=[striketimes,tim]
power=[power,(max(data)-min(data))/robust_sigma(data)]
print,(max(data)-min(data))/robust_sigma(data)
endfor
plotstrikes,striketimes,power
end
