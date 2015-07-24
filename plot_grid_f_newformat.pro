FUNCTION get_data,filename
 n=get_file_size(filename)
 rnd_filename,size_filename
 spawn,'wc '+filename+' > '+size_filename
 get_lun,uuu
 openr,uuu,size_filename
 nn=0L
 m=0L
 readf,uuu,nn,m
 close,uuu
 free_lun,uuu
 ncols=double(m)/double(nn)
 if (ncols ne fix(ncols)) then begin
     print,ncols,fix(ncols),' while reading ',filename
     print,' check out the file "size_filename"'
     spawn,' cat '+size_filename
     stop
     endif
 data=dblarr(ncols,n)
 get_lun,uuu
 openr,uuu,filename
 readf,uuu,data
 close,uuu
 free_lun,uuu
 get_data=data
 spawn,'rm '+size_filename
 return,get_data
 end
 
 
 FUNCTION get_file_size,file
 rnd_filename,size_filename
 spawn,'wc '+file+' > '+size_filename
 n=0L
 openr,luin,size_filename, /get_lun
 readf,luin,n
 close,luin
 free_lun,luin
 spawn,'rm '+size_filename
 get_file_size=n
 return,get_file_size
 end
 
 PRO rnd_filename,filename
 ;
 ; will generate a random filename 
 ;
 ;n=10
 ;digits=fix(randomu(seed,n)*100)
 ;str=''
 ;for i=0,n-1,1 do str=str+string(digits(i))
 ;str=strcompress(str,/remove_all)+'.randomfile'
 ;filename=str
 filename=strcompress(string(long(randomu(seed)*1000000))+'.randomfile',/remove_all)
 return
 end
 
 ;========================================================================
 ; plots a stacked-up plot of frequencies in "grid_f_newformat.dat" 
 !P.CHARSIZE=1.6
 !P.thick=2
 !x.thick=3
 !y.thick=3
 spawn,'grep -v "*" grid_f_newformat.dat > p.dat'
 data=get_data('p.dat')
 n=n_elements(data(0,*))
 print,'n: ',n
 jd=reform(data(0,*))
 p1=reform(data(3,*))
 p2=reform(data(6,*))
 
 caldat,jd,mm,dd,yy,hr,mi,se
 hours=hr+mi/60.+se/3600.0
 idx=where(abs(1./p2-50) lt 0.4)
 plot,xstyle=3,ytitle='f!d50!n [Hz]',hours,1./p2(idx),ystyle=3,psym=-1,xtitle='Hours since last noon'
 oplot,[!X.crange],[50,50],linestyle=1
 ;
 alljd=long(jd(sort(jd)))
 alljd=alljd(uniq(alljd))
 nall=n_elements(alljd)
 for iall=0,nall-1,1 do begin
     print,iall,alljd(iall)
     idx=where(long(jd) eq alljd(iall) and abs(1./p2-50) le 0.2)
     if (iall eq 0) then plot,xrange=[0,24],ystyle=3,xstyle=3,xtitle='Hours since last noon',yrange=[49.7,50+0.2*nall],24.*(jd(idx)-alljd(iall)),1./p2(idx)
     if (iall gt 0) then oplot,24.*(jd(idx)-alljd(iall)),1./p2(idx)+0.2*iall
     oplot,[!x.crange],[50+0.2*iall,50+0.2*iall],linestyle=1
     endfor
 oplot,24.*(jd(idx)-alljd(iall-1)),1./p2(idx)+0.2*(iall-1),color=fsc_color('green')
 for k=1,23,1 do oplot,[k,k],[!Y.crange],linestyle=2
 end
