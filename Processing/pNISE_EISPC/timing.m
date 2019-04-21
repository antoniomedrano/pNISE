clear; clc;

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)*5/8 scrsz(3)*5/8 scrsz(4)*5/8])
hold on;

disp('read and plot NISE points');
% tic

rows = 20;
% 80 = 2.55
% 20 = 0.008

%s = ['M = importdata(''biObjParetoSP' int2str(rows) int2str(rows) '.csv'','','',0);'];
%s = ['M = csvread(''biObjParetoSP' int2str(rows) int2str(rows) '.csv'',1,0);'];
%s = ['M = dlmread(''biObjParetoSP' int2str(rows) int2str(rows) '.csv'','','',1,0);'];
%s = ['M = load(''biObjParetoSP' int2str(rows) int2str(rows) '.csv'');'];
s = ['fid = fopen(''biObjParetoSP' int2str(rows) int2str(rows) '.csv'');'];
eval(s);
st=fread(fid,'*char');
M = sscanf(st,'%f,%f,%f,%f,%f',[5,inf])';

tArea = 0;

% plot the triangle ranges
for i = 1:length(M)-1
    fill([M(i,3), M(i+1,3), M(i,3)], ...
         [M(i,4), M(i+1,4), M(i+1,4)], ...
         [.8, .8, 1], 'EdgeColor','none');
    tArea = polyarea([M(i,3), M(i+1,3), M(i,3)],...
                     [M(i,4), M(i+1,4), M(i+1,4)])...
            + tArea;
end

cells = 2*(8*rows*rows - 18*rows + 10);

G = zeros(length(M)*cells, 5);
% toc

disp('read GW paths');
% tic
for i = 1 : length(M)
    
    %s = ['J = importdata(''gwPoints' int2str(rows) int2str(rows) 'c' int2str(i) '.csv'','','');'];
    %s = ['J = dlmread(''gwPoints' int2str(rows) int2str(rows) 'c' int2str(i) '.csv'');'];
    s = ['fid = fopen(''gwPoints' int2str(rows) int2str(rows) 'c' int2str(i) '.csv'');'];
    eval(s)
    st = fread(fid,'*char');
    J = sscanf(st,'%f,%f,%f,%f,%f',[5,inf])';
    %J = cell2mat(textscan(fid,'%n %n %n %n %n','delimiter',',','CollectOutput',1));
    G((i-1)*cells+1 : i*cells, :) = J;

end
% toc

disp('filter outer paths');
tic
% plot(G(:,3),G(:,4),'o','LineWidth',1,...
%                                  'MarkerEdgeColor','k',...
%                                  'MarkerFaceColor','m',...
%                                  'MarkerSize',1);

% % remove extremely bad paths
% for i = [1 length(M)]
% %for i = 1 : length(M)
%     G = G(G(:,3) < M(i,3) | G(:,4) < M(i,4),:);
% end
% toc
% 
% disp('remove blocked cost gateways');
% tic
% %remove blocked cost gateways
% G(any(isnan(G),2),:) = [];
% toc
% 
% disp('plot gateways, filter to wedges')
% tic

% plot(G(:,3),G(:,4),'o','LineWidth',1,...
%                                  'MarkerEdgeColor','k',...
%                                  'MarkerFaceColor','m',...
%                                  'MarkerSize',1);

% keep points only in wedges
% for i = 2 : length(M) - 1
for i = 1 : length(M)
    G = G(G(:,3) < M(i,3) | G(:,4) < M(i,4), :);
end

% add supported points to G
S = [zeros(length(M),2),M(:,3:4),M(:,1)];
G = [G; S];

%remove duplicate points after sorting
% toc
% disp('double sort');
% tic
G = sortrows(G,4);
G = sortrows(G,3);
% toc
% disp('remove duplicates, extract non-dominated points, insert dummy points');
% tic
G = [G(diff(G(:,3)) ~= 0 | diff(G(:,4)) ~= 0, :) ; G(length(G),:)];
H = zeros(size(G));

% extract only the non-dominated points from the G set
cut = G(1,4);
H(1,:) = G(1,:);
j = 2;
for i = 1 : length(G)
    if G(i,4) < cut
        cut = G(i,4);
        H(j,:) = G(i,:);
        j = j+1;
    end
end
H(j:end,:) = [];

K = zeros(length(H)*2+length(S)-2,size(H,2));

% inserts dummy points to count area of empty triangles
K(1,:) = H(1,:);
for i = 2:length(H)
    K(2*i-2,:) = [-1 -1 H(i,3) H(i-1,4) -1];
    K(2*i-1,:) = H(i,:);
end

K(length(H)*2:end,:) = [S(2:length(S),:)];

pArea = polyarea(K(:,3),K(:,4));

toc

length_H = length(H)
NISE_Wedges_Duality_Gap = tArea
GWArcs_Heur_Duality_Gap = pArea

%H = [G(diff(G(:,4)) < 0,:); G(length(G),:)]

%plot heuristic duality gaps
fill(K(:,3), K(:,4), [.4, .4, 1], 'EdgeColor','none');                             

%plot gateway points
plot(G(:,3),G(:,4),'o','LineWidth',1,...
                                 'MarkerEdgeColor','k',...
                                 'MarkerFaceColor','r',...
                                 'MarkerSize',4);

%plot heuristic pareto points
plot(H(:,3),H(:,4),'o','LineWidth',1,...
                                 'MarkerEdgeColor','k',...
                                 'MarkerFaceColor','y',...
                                 'MarkerSize',6);

% plot the supported points
plot(S(:,3),S(:,4),'o','LineWidth',1,...
                                 'MarkerEdgeColor','k',...
                                 'MarkerFaceColor','b',...
                                 'MarkerSize',7);

%axis tight
hold off;