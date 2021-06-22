%%%Code from Berrios et. al. Nature, 2021 for behavioral analysis of 
%2AFC code from BPOD-SANWORKS. Please be sure to change your directories.
%originally made with MATLAB2016b.

%%select data file
[filename, pathname] = uigetfile;
load([pathname filename]);

%%Extract variables from Struct

a= SessionData.RawEvents.Trial   %%Load struct
TrialData = a;   %%Load array with all trials


%%Collect data for each Paramter

%%Poke.WaitForPortOut=[];             %%initiation
Poke.CueDelay=[];                  %%ITI 
Poke.WaitForResponse=[];           %%Reward Port Poke L or R
Poke.LeftReward=[];                  %%Left Reward delivered
Poke.RightReward=[];                %%Right Reward delivered
Poke.Drinking=[];                  %%Drinking
Poke.Punish=[];                   %%Time out

for i=1:length(a)
    %%Poke.WaitForPortOut = [Poke.WaitForPortOut; diff(a{i}.States.WaitForPortOut(1,:))];
    Poke.CueDelay = [Poke.CueDelay; diff(a{i}.States.CueDelay(1,:))];
    Poke.WaitForResponse = [Poke.WaitForResponse; diff(a{i}.States.WaitForResponse(1,:))];
    Poke.LeftReward = [Poke.LeftReward; diff(a{i}.States.LeftReward(1,:))];
    Poke.RightReward = [Poke.RightReward; diff(a{i}.States.RightReward(1,:))];
    Poke.Drinking = [Poke.Drinking; diff(a{i}.States.Drinking(1,:))];
     Poke.Punish = [Poke.Punish; diff(a{i}.States.Punish(1,:))];
    
end

%% Identify Trials
Miss = find(isnan(Poke.LeftReward) & isnan(Poke.RightReward) & isnan(Poke.Punish)); %%no poke
FalseAlarm = find(isnan(Poke.Punish) < 1); %%Poke in wrong port
Hits = find((isnan(Poke.LeftReward) < 1) + (isnan(Poke.RightReward) < 1)); %%Poke in correct port
NoReward = find(isnan(Poke.LeftReward) & isnan(Poke.RightReward) & isnan(Poke.Punish) & Poke.WaitForResponse < 10);

%% save
cd('C:\Users\XX\Desktop') %%Change to data directory
if ~exist('bPod_analysis')
    mkdir( 'bPod_analysis')
end
save_dir = 'C:\Users\XXXX\bPod_analysis'; %%Change to desired directory for saving
save_fname = filename(strfind(filename, 'COMMONFILENAME')-5:end); %%Change COMMONFILENAME to a common string in each behavioral file
 cd(save_dir)
save([save_dir '\' save_fname], 'Poke' );

%% percentages; quantifies each paramater into a perecentage

H = size(Hits);
Hcalc = H(1);
Hpercent = (Hcalc/i)*100;

M = size(Miss);
Mcalc = M(1);
Mpercent = (Mcalc/i)*100;

F = size(FalseAlarm);
Fcalc = F(1);
Fpercent = (Fcalc/i)*100;

ResponseT = mean(Poke.WaitForResponse);

