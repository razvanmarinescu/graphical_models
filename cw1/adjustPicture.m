function adjustPicture(xLabelArg, yLabelArg, zLabelArg, titleArg)
%% adjustPicture(xLabelArg, yLabelArg, zLabelArg)

% Params that make the pic look nice
hFig = figure(1);
set(hFig, 'Position', [100 100 800 600]);
set(gca,'Fontsize',16);

xlabel(xLabelArg);
if(~isempty(yLabelArg))
  ylabel(yLabelArg);
end

if(~isempty(zLabelArg))
  zlabel(zLabelArg);
end

if(~isempty(titleArg))
  title(titleArg, 'FontWeight','bold');
end  
  
%set(hFig,'LineWidth',2);

end% 