function imp = nfb_checkImpedance(cfg)
% This function implements a resting state protocol to get a baseline level
% of the parameters specified by cfg

try
    
    % Clear the workspace and the screen
    sca;
    close all;
    %PsychPortAudio('Close')
    
    %electrodeLoc = input('Enter electrode location (remember to use quotes): ');
    
    % Here we call some default settings for setting up Psychtoolbox
    
    % Get the screen numbers. This gives us a number for each of the screens
    % attached to our computer.
    screens = Screen('Screens');
    
    % To draw we select the maximum of these numbers. So in a situation where we
    % have two screens attached to our monitor we will draw to the external
    % screen.
    screenNumber = max(screens);
    
    % Define black and white (white will be 1 and black 0). This is because
    % in general luminace values are defined between 0 and 1 with 255 steps in
    % between. All values in Psychtoolbox are defined between 0 and 1
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    
    % Do a simply calculation to calculate the luminance value for grey. This
    % will be half the luminace values for white
    grey = white / 2;
    
    % Open an on screen window using PsychImaging and color it grey.
    
    screenXpixels = 1000;
    screenYpixels = 500;
    
    KbName('UnifyKeyNames');
    
    % Initialize keys
    spaceKey = KbName('space');
    upKey = KbName('UpArrow');
    downKey = KbName('DownArrow');
    leftKey = KbName('LeftArrow');
    rightKey = KbName('RightArrow');
    bsKey = KbName('BackSpace');
    
    lib = lsl_loadlib();
    
    EEGstream = {};
    
    while isempty(EEGstream)
        EEGstream = lsl_resolve_byprop(lib,'type','EEG');
    end
    
    inlet = lsl_inlet(EEGstream{1});
    
    data = [];
    channel = [];
    
    curTime = GetSecs();
    sessionStart = GetSecs();
    lastChunk = GetSecs();
    
    %     for c = 1:length(cfg.params)
    %         barpos(c) = screenXpixels*c/(length(cfg.params)+1);
    %     end
    %
    %     barheight = [0.6*screenYpixels 0.9*screenYpixels];
    %
    data = [];
    chunk = [];
    
    
    %curThreshold = 1; %curThreshold goes from 0 to length(fbands)-1 (easier with mod)
    lastKey = 0;
    
    sessionRecord = cell(1,length(cfg.params));
    
    session = [];
    starttime = GetSecs();
    allimp = [];
    while true
        lastChunk = GetSecs();
        
        %getting a chunk from the stream and updating the current epoch
        
        [chunk timeStamps] = inlet.pull_chunk();
        %session = [session chunk(cfg.chan,:)];
        if ~isempty(chunk)
            allimp = [allimp chunk(cfg.chan,:)];
        end
        
        while isempty(allimp)
            WaitSecs(0.5);
            [chunk] = inlet.pull_chunk();
            %session = [session chunk(cfg.chan,:)];
            allimp = [allimp chunk(cfg.chan,:)];
        end
%         
        imp = mean(allimp((max(1,end-2*cfg.srate)):end));
        msg = ['Impedance: ' num2str(abs(round(imp/1000,4,'significant'))) ' kOhms. Press any key to end impedance check'];
        fprintf([msg '\n'])
        %fprintf([repmat('\b',1,length(msg)*2+3) msg])
        
        [keyIsDown,~,keyCode] = KbCheck;
        
        if keyIsDown
            lastKey = 1;
        end
        
        if ~keyIsDown && lastKey
            return;
        end
        
        WaitSecs(0.1);
    end
    
catch
    sca;
    psychrethrow(psychlasterror);
end

end