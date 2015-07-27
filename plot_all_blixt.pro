PRO possiblypaddata,data
 ; will add tow columns to data if it onlyhas 1
 l=size(data)
 if (l(1) eq 1) then begin
     n=l(2)
     col=fltarr(n)*0.0-911.0
     table=[transpose(reform(data)),transpose(col),transpose(col)]
     data=table
     endif
 return
 end
 
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
 
 
 ;====================================================
 !P.CHARSIZE=1.9
 rate=get_data('rate.txt')
 rate=rate(0)
 files=file_search('OUT/blixt*',count=n)
 striketimes=[]
 power=[]
 w=30.*(rate/44100.)
 sum=[]
 for i=0,n-1,1 do begin
     data=get_data(files(i))
     possiblypaddata,data
     idx=where(data(0,*) eq max(data(0,*)))
     piece=reform(data(0,idx(0)-w:idx(0)+w))
     t=findgen(2*w+1)/rate	; seconds
     t=t*1000.	;mili-seconds
help,t,piece
     !P.MULTI=[0,1,3]
     plot,t,piece,ystyle=3,xstyle=3,xtitle='Time [milli-seconds]',ytitle='Event, and avg (red)'
     sum=[[sum],[piece]]
     if (i gt 3) then oplot,t,avg(sum,1),color=fsc_color('red')
     plot,t,data(1,idx(0)-w:idx(0)+w),ystyle=3,xstyle=3,xtitle='Time [milli-seconds]',ytitle='Event'
     getstriketime,files(i),tim
     striketimes=[striketimes,tim]
     power=[power,(max(data(0,*))-min(data(0,*)))/robust_sigma(data(0,*))]
     print,(max(data(0,*))-min(data(0,*)))/robust_sigma(data(0,*))
     endfor
 print,'Found at total of ',n,' probable strikes.'
 plotstrikes,striketimes,power
 end
