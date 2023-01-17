a1= bibd(:,1);
b1= bibd(:,2);

plot(a1,b1,'o--')
title('Connectivity');
xlabel('No. of Keys');
ylabel('Sharing atleast one link');

  hold on;
b2= bibd(:,3);
plot(a1,b2,'+--');
    hold on;

b3= bibd(:,4);
plot(a1,b3,'*--');
 hold off;
 legend('RKP','KWD','Proposed')
set(gca,'Fontsize',16);