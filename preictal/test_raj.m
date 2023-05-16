clc;
close all;
clear all;
load preictal50.mat;
s=preictal;
p=plot(s(1:1024));
title('EEG Signal')
count=0; 
c = s(:)';
sig=c;
N = length(c);
imf = []; 

while (1)  
  
   h = c; 
   SD = 1; 
   
   while SD > 0.3
    
      d = diff(h); 
      maxmin = []; 
      for i=1:N-2
         if d(i)==0                     
            maxmin = [maxmin, i];
         elseif sign(d(i))~=sign(d(i+1))  
            maxmin = [maxmin, i+1];        
         end
      end
      
      if size(maxmin,2) < 2
         break
      end
      
    
      if maxmin(1)>maxmin(2)              
         maxes = maxmin(1:2:length(maxmin));
         mins  = maxmin(2:2:length(maxmin));
      else                                
         maxes = maxmin(2:2:length(maxmin));
         mins  = maxmin(1:2:length(maxmin));
      end
    
      maxes = [1 maxes N];
      mins  = [1 mins  N];
      

      % spline interpolate to get max and min envelopes; form imf
      maxenv = spline(maxes,h(maxes),1:N);
      minenv = spline(mins, h(mins),1:N);
      
      m = (maxenv + minenv)/2; 
      prevh = h; 
    figure;
    hold on
    plot(c);
    plot(maxenv,'-r');
    plot(minenv,'-r');
    plot(m,'-k');
    title('Process of interpolation showing hidden ridal waves')
   
    hold off;
    pause(5);
    close all;
      
      
      
      
      h = h - m; 
       
      eps = 0.0000001; 
      SD = sum ( ((prevh - h).^2) ./ (prevh.^2 + eps) );
      
   end
   
   imf = [imf; h]; 
  
   count=count+1;
      
   if size(maxmin,2) < 2
      break
   end
   
 
   
  
  
 
end


for ii=1:count
  subplot(count,1,ii);
  plot(imf(ii,:));
  title(sprintf("IMF: %d",ii));
    
end




