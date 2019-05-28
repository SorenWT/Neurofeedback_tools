function run_nfb(protocol_script)
% run_nfb is the main script for the neurofeedback library. It takes a
% protocol script (a script that sets up the config structure for your
% protocol) as an input, and guides you through the startup of LSL
%
% Currently only single-channel neurofeedback is implemented. The script
% assumes this channel uses one of the N-inputs and the default board
% settings


% First run a protocol script
cfg = protocol_script();

disp('Neurofeedback')
disp(['Protocol: ' cfg.protocolname])
disp(date)
disp('')
disp('Please connect your board and start LabStreamingLayer with impedance option to continue')
disp('When finished, enter y. For instructions, type h. To exit, type exit')


behav = input('','s');
while ~strcmpi(behav,'y')
    if strcmpi(behav,'h') || strcmpi(behav,'help')
        disp('Open the terminal and cd to the directory containing openbci_lsl.py')
        disp('Run the command: python openbci_lsl.py --stream')
        disp(['If the board connects, run the command: z' num2str(cfg.chan) '01Z'])
        disp(['This should set the board up for impedance measurement on channel ' num2str(cfg.chan)])
        disp('Then enter /start to start streaming')
        disp('When finished, enter y at the MATLAB command prompt to continue')
        disp('')
        behav = input('','s');
    elseif strcmpi(behav,'exit')
        disp('Exiting')
        return;
    else
        behav = input('Unrecognized input - try again','s');
    end
end

lastimp = nfb_checkImpedance(cfg);

WaitSecs(0.5)
disp('')
behav = input(['Impedance measured at ' num2str(lastimp) 'kOhms. Continue session? y/n'],'s');

while ~strcmpi(behav,'n') && ~strcmpi(behav,'y')
    behav = input('Unrecognized input - try again','s');
end

if strcmpi(behav,'n')
    disp('Aborting session due to bad impedance')
    disp('Remember to exit LSL')
    return;
elseif strcmpi(behav,'y')
    disp(['Continuing session with impedance ' lastimp 'kOhms'])
    disp('')
end

disp('Please reset the channel behaviour in LSL to the default settings.')
behav = input('When finished, enter y to continue. Type h for help. Type exit to exit','s');

while ~strcmpi(behav,'y')
    if strcmpi(behav,'h')
        disp('Stop the data stream by using the command /stop')
        disp('Reset the default channel settings with the command d')
        disp('Restart the stream with /start')
        disp('')
        behav = input('When finished, enter y to continue. Type h for help. Type exit to exit','s');
    elseif strcmpi(behav,'exit')
        disp('Exiting')
        return
    else
        behav = input('Unrecognized input - try again','s');
    end
end

behav = input('Enter y to begin baseline measurement. Type exit to exit','s');

while ~strcmpi(behav,'y') && ~strcmpi(behav,'exit')
    behav = input('Unrecognized input - try again','s');
end

if strcmpi(behav,'y')
    cfg = nfb_getThreshold(cfg);
elseif strcmpi(behav,'exit')
    disp('Exiting')
    return;
end

disp('Baseline complete')
disp('')

behav = input('Enter y to begin neurofeedback. Type exit to exit','s');

while ~strcmpi(behav,'y') && ~strcmpi(behav,'exit')
    behav = input('Unrecognized input - try again','s');
end

if strcmpi(behav,'y')
    nfb_main(cfg);
elseif strcmpi(behav,'exit')
    disp('Exiting')
    return;
end
