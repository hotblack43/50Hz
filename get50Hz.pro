PRO get50Hz,sound_in,Hz,rate
sound=double(sound_in)
left=reform(sound(0,*))
right=reform(sound(1,*))
print,mean(left),mean(righT)
left=left-mean(left)
right=right-mean(right)
sound=sqrt(left^2+right^2)
lengthinseconds=n_elements(sound)/float(rate)	; in seconds
n=n_elements(sound)
z=fft(sound*hanning(n),-1)
zz=z*conj(z)
zz=reform(sqrt(float(zz)))
         f=dindgen(n)/4.0d0
idx=where(f gt 30 and f le 70)
Hz=f(where(zz eq max(zz(idx))))
!P.MULTI=[0,1,2]
plot,findgen(n_elements(sound))/n_elements(sound)*lengthinseconds,sound,xtitle='time [s]',ytitle='Signal'
plot_io,f(idx),zz(idx),xtitle='f [Hz]'
end
openw,33,'frequencies.dat'

    for i=0,3600./4./2.,1 do begin
         spawn,'arecord -D plughw:1 --duration=4 -f cd test1.wav'
	 time=systime(/julian)
         sound=read_wav('test1.wav',rate)
         idx=where(finite(sound) ne 1)
         jdx=where(finite(sound) eq 1)
         if (jdx(0) eq -1) then stop
         if (idx(0) ne -1) then sound(idx)=(median(sound(jdx)))
	 get50Hz,sound,Hz,rate
	 print,format='(f15.7,1x,f9.4)',time,Hz(0)
	 printf,33,format='(f15.7,1x,f9.4)',time,Hz(0)
	endfor
close,33
data=get_data('frequencies.dat')
t=reform(data(0,*))
f=reform(data(1,*))
plot,t,f,ystyle=3,xstyle=3
end
