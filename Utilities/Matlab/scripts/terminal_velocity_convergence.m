% Trettel
% last updated 2011-07-19

close all
clear all

plot_style

repository = '../../../Verification/Sprinklers_and_Sprays/';

g = 9.8;
Cd = 1;
rhoa = 1.19926615231088;
rhod = 1000;
D = 10e-3;

tend = 20;
eps = 1e-10;
ttest = 0.1;

K = 3 * rhoa * Cd / (4 * rhod * D);

errvec = [];
Linf = [];
vtexact = sqrt(g / K);
zexact = @(t) -log(cosh(sqrt(g * K) * t)) / K;
[STIME, XP, YP, ZP, QP] = read_prt5([repository, 'terminal_velocity_dt=1_0.prt5'],'real*4');
dtvec = [1.0 0.1 0.01 0.001 0.0001];
errvec(1) = abs(abs(QP(length(QP))) - vtexact);
Linf(1) = norm(ZP' - zexact(STIME), Inf);
%errtvec(1) = abs(ZP(find(abs(STIME - ttest) < eps, 1))' - zexact(ttest));
[STIME, XP, YP, ZP, QP] = read_prt5([repository, 'terminal_velocity_dt=0_1.prt5'],'real*4');
errvec(2) = abs(abs(QP(length(QP))) - vtexact);
Linf(2) = norm(ZP' - zexact(STIME), Inf);
%errtvec(2) = abs(ZP(find(abs(STIME - ttest) < eps, 1))' - zexact(ttest));
[STIME, XP, YP, ZP, QP] = read_prt5([repository, 'terminal_velocity_dt=0_01.prt5'],'real*4');
errvec(3) = abs(abs(QP(length(QP))) - vtexact);
Linf(3) = norm(ZP' - zexact(STIME), Inf);
%errtvec(3) = abs(ZP(find(abs(STIME - ttest) < eps, 1))' - zexact(ttest));
[STIME, XP, YP, ZP, QP] = read_prt5([repository, 'terminal_velocity_dt=0_001.prt5'],'real*4');
errvec(4) = abs(abs(QP(length(QP))) - vtexact);
Linf(4) = norm(ZP' - zexact(STIME), Inf);
%errtvec(4) = abs(ZP(find(abs(STIME - ttest) < eps, 1))' - zexact(ttest));
[STIME, XP, YP, ZP, QP] = read_prt5([repository, 'terminal_velocity_dt=0_0001.prt5'],'real*4');
errvec(5) = abs(abs(QP(length(QP))) - vtexact);
Linf(5) = norm(ZP' - zexact(STIME), Inf);
%errtvec(6) = abs(ZP(find(abs(STIME - ttest) < eps, 1))' - zexact(ttest));

figure(1)

set(gca, 'Units', Plot_Units)
set(gca, 'Position', [Plot_X, Plot_Y, Plot_Width, Plot_Height])
set(gcf, 'DefaultLineLineWidth', Line_Width)

H(1) = loglog(dtvec, errvec, '-*k');
hold on
H(2) = loglog(dtvec, dtvec, '--k');
H(3) = loglog(dtvec, dtvec.^2, '-k');
hold off
dto = dtvec((length(dtvec) - 1):length(dtvec));
erro = errvec((length(errvec) - 1):length(errvec));
[a, b] = polyfit(log(dto), log(erro), 1);
%fprintf('order of accuracy: %f\n', a(1))

set(gca, 'FontName', Font_Name)
set(gca, 'FontSize', Key_Font_Size)

xlabel('Time Step, $\delta t$ (s)', 'Interpreter', 'LaTeX','FontSize',Label_Font_Size)
ylabel('Terminal Velocity Error','FontSize',Label_Font_Size)
h = legend(H, 'FDS', '$\mathcal{O}(\delta t)$',...
    '$\mathcal{O}(\delta t^2)$', 'Location', 'Southeast');
set(h,'Interpreter', 'LaTeX')

set(gcf, 'Visible', Figure_Visibility);
set(gcf, 'PaperUnits', Paper_Units);
set(gcf, 'PaperSize', [Paper_Width Paper_Height]);
set(gcf, 'PaperPosition', [0 0 Paper_Width Paper_Height]);

SVN_Filename = [repository, 'terminal_velocity_dt=1_0_svn.txt'];
if exist(SVN_Filename,'file')
    SVN = importdata(SVN_Filename);
    x_lim = get(gca,'XLim');
    y_lim = get(gca,'YLim');
    X_SVN_Position = 10^( log10(x_lim(1))+ SVN_Scale_X*( log10(x_lim(2)) - log10(x_lim(1)) ) );
    Y_SVN_Position = 10^( log10(y_lim(1))+ SVN_Scale_Y*( log10(y_lim(2)) - log10(y_lim(1)) ) );
    text(X_SVN_Position,Y_SVN_Position,['SVN ',num2str(SVN)], ...
        'FontSize',10,'FontName',Font_Name,'Interpreter','LaTeX')
end

display('Printing plot terminal_velocity_convergence.pdf...')
print(gcf, '-dpdf', '../../../Manuals/FDS_Verification_Guide/SCRIPT_FIGURES/terminal_velocity_convergence');

close all
clear H
figure(1)

set(gca, 'Units', Plot_Units)
set(gca, 'Position', [Plot_X, Plot_Y, Plot_Width, Plot_Height])
set(gcf, 'DefaultLineLineWidth', Line_Width)

H(1) = loglog(dtvec, Linf, '-*k');
hold on
H(2) = loglog(dtvec, 50 * dtvec, '--k');
H(3) = loglog(dtvec, 5 * dtvec.^2, '-k');
hold off
dto = dtvec((length(dtvec) - 1):length(dtvec));
erro = Linf((length(Linf) - 1):length(Linf));
[a, b] = polyfit(log(dto), log(erro), 1);
%fprintf('order of accuracy: %f\n', a(1))

set(gca, 'FontName', Font_Name)
set(gca, 'FontSize', Key_Font_Size)

xlabel('Time Step, $\delta t$ (s)', 'Interpreter', 'LaTeX','FontSize',Label_Font_Size)
ylabel('Position Error','FontSize',Label_Font_Size)
h = legend(H, 'FDS', '$\mathcal{O}(\delta t)$',...
    '$\mathcal{O}(\delta t^2)$', 'Location', 'Southeast');
set(h,'Interpreter', 'LaTeX')

set(gcf, 'Visible', Figure_Visibility);
set(gcf, 'PaperUnits', Paper_Units);
set(gcf, 'PaperSize', [Paper_Width Paper_Height]);
set(gcf, 'PaperPosition', [0 0 Paper_Width Paper_Height]);

SVN_Filename = [repository, 'terminal_velocity_dt=1_0_svn.txt'];
if exist(SVN_Filename,'file')
    SVN = importdata(SVN_Filename);
    x_lim = get(gca,'XLim');
    y_lim = get(gca,'YLim');
    X_SVN_Position = 10^( log10(x_lim(1))+ SVN_Scale_X*( log10(x_lim(2)) - log10(x_lim(1)) ) );
    Y_SVN_Position = 10^( log10(y_lim(1))+ SVN_Scale_Y*( log10(y_lim(2)) - log10(y_lim(1)) ) );
    text(X_SVN_Position,Y_SVN_Position,['SVN ',num2str(SVN)], ...
        'FontSize',10,'FontName',Font_Name,'Interpreter','LaTeX')
end

display('Printing plot position_convergence.pdf...')
print(gcf, '-dpdf', '../../../Manuals/FDS_Verification_Guide/SCRIPT_FIGURES/position_convergence');

% figure(1)
% H(1) = loglog(dtvec, errtvec, '-*k');
% hold on
% H(2) = loglog(dtvec, 50 * dtvec, '--k');
% H(3) = loglog(dtvec, 10 * dtvec.^2, '-k');
% hold off
% dto = dtvec((length(dtvec) - 1):length(dtvec));
% erro = errtvec((length(errtvec) - 1):length(errtvec));
% [a, b] = polyfit(log(dto), log(erro), 1);
% fprintf('order of accuracy: %f\n', a(1))
% figure(1)
% plot_style
% 
% set(gca, 'Units', Plot_Units)
% set(gca, 'Position', [Plot_X, Plot_Y, Plot_Width, Plot_Height])
% set(gcf, 'DefaultLineLineWidth', Line_Width)
% 
% set(gca, 'FontName', Font_Name)
% set(gca, 'FontSize', Key_Font_Size)
% 
% xlabel('Time Step, $\delta t$ (s)', 'Interpreter', 'LaTeX')
% ylabel('Position Error')
% h = legend(H, 'FDS', '$\mathcal{O}(\delta t)$',...
%     '$\mathcal{O}(\delta t^2)$', 'Location', 'Southeast');
% set(h,'Interpreter', 'LaTeX')
% 
% set(gcf, 'Visible', Figure_Visibility);
% set(gcf, 'PaperUnits', Paper_Units);
% set(gcf, 'PaperSize', [Paper_Width Paper_Height]);
% set(gcf, 'PaperPosition', [0 0 Paper_Width Paper_Height]);
% 
% SVN_Filename = [repository, 'terminal_velocity_dt=1_0_svn.txt'];
% if exist(SVN_Filename,'file')
%     SVN = importdata(SVN_Filename);
%     x_lim = get(gca,'XLim');
%     y_lim = get(gca,'YLim');
%     X_SVN_Position = 10^( log10(x_lim(1))+ SVN_Scale_X*( log10(x_lim(2)) - log10(x_lim(1)) ) );
%     Y_SVN_Position = 10^( log10(y_lim(1))+ SVN_Scale_Y*( log10(y_lim(2)) - log10(y_lim(1)) ) );
%     text(X_SVN_Position,Y_SVN_Position,['SVN ',num2str(SVN)], ...
%         'FontSize',10,'FontName',Font_Name,'Interpreter','LaTeX')
% end
% 
% print(gcf, '-dpdf', '../../../Manuals/FDS_Verification_Guide/SCRIPT_FIGURES/position_convergence');
