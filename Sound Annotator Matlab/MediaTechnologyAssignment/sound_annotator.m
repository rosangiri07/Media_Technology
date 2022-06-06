function varargout = sound_annotator(varargin)
% SOUND_ANNOTATOR MATLAB code for sound_annotator.fig
%      SOUND_ANNOTATOR, by itself, creates a new SOUND_ANNOTATOR or raises the existing
%      singleton*.
%
%      H = SOUND_ANNOTATOR returns the handle to a new SOUND_ANNOTATOR or the handle to
%      the existing singleton*.
%
%      SOUND_ANNOTATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SOUND_ANNOTATOR.M with the given input arguments.
%
%      SOUND_ANNOTATOR('Property','Value',...) creates a new SOUND_ANNOTATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sound_annotator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sound_annotator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sound_annotator

% Last Modified by GUIDE v2.5 02-May-2020 11:29:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sound_annotator_OpeningFcn, ...
                   'gui_OutputFcn',  @sound_annotator_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before sound_annotator is made visible.
function sound_annotator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sound_annotator (see VARARGIN)

% Choose default command line output for sound_annotator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sound_annotator wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Making these below operations as a global variable so that we don't have
%to declare the variable everytime we use in some functions

% To find out wheather main audio player is playing presently.
global audioPlaying1;
% To find out wheather main audio player is loaded or not presently.
global audioLoader1;
% To find out wheather main audio player is paused presently or not.
global audioPaused1; 
% To store the audio in the main audio player
global audioData1; 

%At the launch of the system the audioPlaying, audioLoader, audioPaused and audioData should not be loaded so the output is false at the time and only becomes true when user performs action on the system
audioPlaying1 = false; %At the beginning the audio is not playing so it is make false, it only becomes true when audio is playing
audioLoader1 = false; %At the beginning the audio is not loaded so it is make false, it only becomes true when audio is loaded
audioPaused1 = false;%At the beginning the audio is not paused so it is make false, it can only be true when the audio is playing and the user click the pause button
audioData1 = 0;% The audio data in the main audio player is currently null.


global audioPlaying2 % To find out wheather second audio player is playing presently or not.
global audioLoader2 % To find out wheather second audio player is loaded presently or not.
global audioPaused2; % To find out wheather second audio player is paused presently or not.
global audioData2; % To store the data of the second audio player.

%At initial stage all the values is false because neither action is
%performed 
audioPlaying2 = false;%At the beginning the audio is not playing so it is make false, it only becomes true when audio is playing
audioLoader2 = false;%At the beginning the audio is not loaded so it is make false, it only becomes true when audio is loaded
audioPaused2 = false;%At the beginning the audio is not paused so it is make false, it can only be true when the audio is playing and the user click the pause button
audioData2 = 0; %The audio data in the second audio player is currently null.

%The audio sampling rate is used to store the sampling rate on audio files
global audioSamplingRate; 
audioSamplingRate = 48000; %The value given is the global sampling rate value
global audioSpeedChanged; %Tracks whether the audio speed is changed or not
audioSpeedChanged = false;% Initially the audio speed is not change so it is false

%This function is used for adding labels in main audio player and second audio player
function axesLabels(hObject)

    axes = hObject;
    
    axes.XLabel.String = 'Time Per Second'; %X-axis label of the respective audio player axes
    axes.YLabel.String = 'Audio Amplitude';%Y-axis label of the respective audio player axes
   

% This function is used to load files in the respective audio players. Mp3 and wav audio files can be loaded into the application

function loadFile(handles, audio) 

    global audioSamplingRate; %Sampling Rate of the audio file 
    global audioSpeedChanged; %Speed 
  %It gives options to user to select audio file type  
[filename,pathname] = uigetfile( ...
{'*.wav;*.mp3',...
'Audio Files (*.wav,*.mp3)'; ...
'*wav', 'WAV Files(*.wav)';...
'*mp3', 'MP3 Files(*.mp3)';},...
'IMPORT AUDIO'); % Shows message to import audio

if filename
    
    [sampleData,SRD]=audioread(fullfile(pathname, filename)); %The term SRD refers to the sample rate for the respective data file 
    
    if audio == 1 %When audio is loaded into the main audio player
        global audioData1; %Main audio player variable
        global audioSound1;
        global audioPlaying1;
        audioPlaying1 = false;
        global audioPaused1;
        audioPaused1 = false;
        global audioLoader1;
        audioLoader1 = true;
        
    if SRD ~= audioSamplingRate %This line of code checks whether the sample rate of the audio match the global sample or not
        [P,Q] = rat(audioSamplingRate/SRD); %The global audio sampling rate is divided by the loaded audio rate to calculate the rationale approximation
        audioData1 = resample(sampleData,P,Q); % This line of code uses the new sample rate passed by the rat function from the above code
    else
        audioData1 = sampleData; % If the upper case does not match then the sample data is considered as the audio data
    end
        
        audioSound1 = audioplayer(audioData1,audioSamplingRate); %This line of code replaces the audio data and sampling rate of the audio file of the audio sound
        %The below code is used for updating the timer of the audio file and sets the timer including the stop aduio function 
        set(audioSound1,'TimerFcn',{@updateTimer,audio, handles},  'TimerPeriod', 0.1,  'StopFcn',{@audioEnd, audio, handles});  
        set(handles.mainAudioReverse,'Value', 0);% This line of code sets the reverse  function of the main audio player to its original format 
        updateGUI(audioData1, audioSamplingRate, handles, audio); %This line of code updates the graphical user interface of the respective audio player with the loaded audio file
        
    elseif audio == 2 %When audio is loaded into the second audio player
        
        %Second audio player global variable
        global audioData2;
        global audioSound2;
        global audioPlaying2;
        audioPlaying2 = false;
        global audioPaused2;
        audioPaused2 = false;
        global audioLoader2;
        audioLoader2 = true;
        
        if SRD ~= audioSamplingRate %This line of code checks whether the sample rate of the audio match the global sample or not
           [P,Q] = rat(audioSamplingRate/SRD);%The global audio sampling rate is divided by the loaded audio rate to calculate the rationale approximation
           audioData2 = resample(sampleData,P,Q);% This line of code uses the new sample rate passed by the rat function from the above code
           
        else
             audioData2 = sampleData;% If the upper case does not match then the sample data is considered as the audio data
        end
        
        audioSound2 = audioplayer(audioData2,audioSamplingRate); %This line of code replaces the audio data and sampling rate of the audio file of the audio sound
        %The below code is used for updating the timer of the audio file and sets the timer including the stop aduio function
        set(audioSound2,'TimerFcn',{@updateTimer,audio, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@audioEnd, audio, handles});       
        set(handles.secondAudioReverse,'Value', 0);% This line of code sets the reverse  function of the second audio player to its original format 
        updateGUI(audioData2, audioSamplingRate, handles, audio);%This line of code updates the graphical user interface of the respective audio player with the loaded audio file
    end
    
    if(audioSpeedChanged) %This line of code checks the audio speed of the file
       speedRestoration(handles);%If the audio speed is changed it restores the speed of the audio to the original audio speed
       
    end
    
end

%This function is used for updating the graphical user interface of the audio players
function updateGUI(sampleData, SRD, handles, audio)% This function is called when the audio player need update
%It updates the audio data, sampling rate of the audio and the handles of the audio players

time=round((1/SRD)*length(sampleData),1); %This line of code calculates the time of tha audio file of respective audio player

if audio == 1 
   axes = handles.axes3; %Handles the main audio player axes
   slider = handles.axes3Slider; %Handles the main audio player slider
   set(handles.mergeSlider, 'MAX', time); %This line of code sets the slider value to merge the two audio files
   set(handles.mergeSlider, 'VALUE', 0);
   set(handles.mergeSlider, 'MIN', 0);
   
elseif audio == 2
    
    axes = handles.axes4; %Handles the second audio player axes
    slider = handles.axes4Slider;%Handles the second audio player slider
    
end

t=linspace(0,time,length(sampleData));

plot(axes,t,sampleData); %This line of code plots the audio data into the respective audio player axes
axesLabels(axes); % This line is used for adding labels to the axes
set(slider, 'MAX', time);
set(slider, 'VALUE', 0);
set(slider, 'MIN', 0);

%This function is used for updating the time of audio file in each player i.e main audio player and second audio player
function updateTimer(~,~,audio, handles) %Updates the times in respective audio player when the audio is playing
    global audioSamplingRate;

    if audio == 1
        global audioSound1;
        global audioData1;
    
        slider = handles.axes3Slider;%Handles the slider of the main audio player
        text = handles.axes3SliderText;%Handles the audio time in the main auio player
        time = round(audioSound1.CurrentSample / audioSamplingRate,1);%Calulate the audio time in seconds in main audio player based on the current sample data
        sampleData = audioData1; %The sample data is equals to the audio data of the main auio player
    
    elseif audio == 2
        global audioSound2;
        global audioData2;
    
        slider = handles.axes4Slider; %Handles the slider of the second audio player
        text = handles.axes4SliderText;%Handles the timer of the second audio player
        time = round(audioSound2.CurrentSample / audioSamplingRate,1);%Calulate the audio time in seconds in second audio player based on the current sample data
        sampleData = audioData2;
    end

    closingTime = get(slider, 'MAX'); %This line of code is used for collecting the audio duration of the audio of respective audio players

    if time < closingTime % This means that the audio file is not finished playing
    
        set(slider, 'VALUE', time);%Sets the slider to the current time playing of the audio file
        set(text, 'String', time);%Sets the slider text to the current time playing of the audio file
    
    else %When the audio is finished playing
    
        set(slider, 'VALUE', closingTime); %Sets the slider time to the current finish time
        set(text, 'String', closingTime);%Sets the slider text to the current finish time
        
        updateGUI(sampleData,audioSamplingRate,handles,audio); %This line of code is used for updating and reseting the time of the audio file
    end

%This playAudio function is used to play audio on audio players
%i.e. audio ==1 is main audio player and audio==2 is second audio player

function playAudio(audio) 

if audio == 1 %When the audio is loaded into the main audio player
    %Main audio player global variables
    global audioSound1;
    global audioPlaying1;
    global audioLoader1;
    global audioPaused1;
    
    if ~audioPlaying1 && audioLoader1
       resume(audioSound1); %Resumes the audio sound of the main audio player
       audioPlaying1 = true; %The audio is playing when the value is true
       audioPaused1 = false;%The audio is not paused when the audio is playing. When the audioplaying is false then the audiopaused would be true
    end
    
    elseif audio == 2 %When the audio is loaded into the second audio player
        %Second audio player global variables
        global audioSound2;
        global audioPlaying2;
        global audioLoader2;
        global audioPaused2;
        
    if ~audioPlaying2 && audioLoader2
        resume(audioSound2);%Resumes the audio sound of the main audio player
        audioPlaying2 = true;%The audio is playing when the value is true
        audioPaused2 = false;%The audio is not paused when the audio is playing. When the audioplaying is false then the audiopaused would be true
        
    end
    
end


%This pauseAudio function is used to pause audio on audio players
%i.e. audio ==1 is main audio player and audio==2 is second audio player
    
function pauseAudio(audio)

    if audio == 1
        global audioSound1;
        global audioPlaying1;
        global audioPaused1;
    
        audioPlaying1 = false;
        audioPaused1 = true;
        pause(audioSound1);
        
    elseif audio == 2
         global audioSound2;
         global audioPlaying2;
         global audioPaused2;
    
         audioPlaying2 = false;
         audioPaused2 = true;
         pause(audioSound2);
    end

  
%This stopAudio function is used to stop audio on audio players
%i.e. audio ==1 is main audio player and audio==2 is second audio player
%and returns it back to the start of the audio file

function stopAudio(handles, audio) 

    if audio == 1
        
        global audioLoader1;
        global audioSound1;
        global audioPlaying1;
        global audioPaused1;
    
    if  audioLoader1 
        
        audioPlaying1 = false;
        audioPaused1 = false;
        stop(audioSound1);%Stops the audio in the main audio player
        set(handles.axes3Slider, 'VALUE', get(handles.axes3Slider, 'MIN')); %The below code sets the slider of the main audio player to the beginning
        set(handles.axes3SliderText, 'String', round(handles.axes3Slider.Value, 1));%The below code is used for resetting the timer label of the main audio player
    
    end
    
    elseif audio == 2
        global audioLoader2;
        global audioSound2;
        global audioPlaying2;
        global audioPaused2;
    
    if  audioLoader2 
        audioPlaying2 = false;
        audioPaused2 = false;
        stop(audioSound2);%Stops the audio file in second audio player
        % The following code is used for resetting the second audio player
        % slider and label of the slider
        set(handles.axes4Slider, 'VALUE', get(handles.axes4Slider, 'MIN')); %Resets the second audio player slider to the start of the audio file 
        set(handles.axes4SliderText, 'String', round(handles.axes4Slider.Value, 1)); %Resets the second audio player timer text
    end
    end


%This function is used when an audio is paused or wheather the audio is finished
function audioEnd(~,~,audio, handles) 

    global audioPlaying1;
    global audioPlaying2;

if audio == 1
    
    if audioPlaying1 == true %Checks whether the audio is finished or not
       audioPlaying1 = false;
       set(handles.axes3Slider, 'VALUE', get(handles.axes3Slider, 'MIN')); %Sets the slider of the main audio player to the beginning of the audio file
       
       if get(handles.mainAudioLoop, 'Value') == true %Checks whether the loop checkbox is marked or not
          playAudio(1); %If the loop checkbox is marked true then the audio is played again in the main audio player
   
       end
        
    end
elseif audio == 2
    
    if audioPlaying2 == true %Checks whether the audio is finished or not
       audioPlaying2 = false;
       set(handles.axes4Slider, 'VALUE', get(handles.axes4Slider, 'MIN'));%Sets the slider of the second audio player to the beginning of the audio file
       
        if get(handles.secondAudioLoop, 'value') == true %Checks whether the loop checkbox is marked or not
           playAudio(2);%If the loop checkbox is marked true then the audio is played again in the second audio player
           
        end
    end
end

%The function saveAudio() is used to save audio files in the system.
function saveAudio()

    global audioData1;
    global audioLoader1;
    global audioSamplingRate;

    if audioLoader1 %When audio one is loaded
         foldername = uigetdir('','Folder Selection'); %Opens folders to save the respective audio file
        if foldername
                filename = inputdlg('AudioName:',... % For entering the name of the audio file
                     'Name of the audio file', [1 50]); %Checks the name length of the audio file
            if length(filename) == 1 %This line of code checks whether the name of the audio file was inserted or not
                    path = strcat(foldername,'\',filename,'.wav'); %Checks the filename and path to save the audio fle
                if exist(path{1}, 'file') == 2 
                        confirmation = questdlg('Save Audio');
                    if strcmp(confirmation,'Yes') %This line of code shows the user confirmation for saving the audi file
                           audiowrite(path{1},audioData1,audioSamplingRate);
                    end
                else
                     audiowrite(path{1},audioData1,audioSamplingRate); % This line of code saves the audio file into the choosen folder
                end
            end
        end
    end



%This function is used for reversing the respective audio files
function reverseAudio(handles, audio)

    global audioLoader1;
    global audioLoader2;
    global audioSamplingRate;
    global audioSpeedChanged;
    
    stopAudio(handles, audio);

if audio == 1 && audioLoader1 
    
    global audioData1;
    global audioSound1;
    
    % The flipud function is used for flipping the audio file
    audioData1 = flipud(audioData1);
    audioSound1 = audioplayer(audioData1,audioSamplingRate);
    
    set(audioSound1,'TimerFcn',{@updateTimer, audio, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@audioEnd, audio, handles}); 
    set(handles.axes3SliderText, 'String', round(handles.axes3Slider.Value, 1)); 
    
    updateGUI(audioData1, audioSamplingRate, handles, 1);
    
elseif audio == 2 && audioLoader2
    
    global audioData2;
    global audioSound2;
    
    audioData2 = flipud(audioData2); 
    audioSound2 = audioplayer(audioData2,audioSamplingRate); 
    
    set(audioSound2,'TimerFcn',{@updateTimer, audio, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@audioEnd, audio, handles}); 
    set(handles.axes4SliderText, 'String', round(handles.axes4Slider.Value, 1));
    
    updateGUI(audioData2, audioSamplingRate, handles, 2);
end

    if(audioSpeedChanged) 
        speedRestoration(handles);
    end


%This function is used for manipulation of speed of the audio files
function speedManipulationRate(handles, sampleMultiplier)

    global audioData1;
    global audioData2;
    global audioSamplingRate;
    global audioSound1;
    global audioSound2;
    global audioPlaying1;
    global audioPlaying2;
    global audioLoader1;
    global audioLoader2;
    global audioSpeedChanged;
    audioSpeedChanged = true;

    resumeAudio1 = audioPlaying1; 
    resumeAudio2 = audioPlaying2;

    newSamplingRate = audioSamplingRate * sampleMultiplier; 

    if(audioLoader1) 
        audioSound1 = audioplayer(audioData1, newSamplingRate);
        
        set(audioSound1,'TimerFcn',{@updateTimer,1, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@audioEnd, 1, handles});
        stopAudio(handles,1); 
        
        if(resumeAudio1) 
            playAudio(1);
        end
    end

    if(audioLoader2)
        audioSound2 = audioplayer(audioData2, newSamplingRate);
        
        set(audioSound2,'TimerFcn',{@updateTimer,2, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@audioEnd, 2, handles});
        stopAudio(handles,2);
        
        if(resumeAudio2)
            playAudio(2);
        end
    end
    
%This function is used to restore the audio file and speed of the audio
function speedRestoration(handles)
    global audioSpeedChanged;
    
    if(audioSpeedChanged)
        
        speedManipulationRate(handles, 1); 
        set(handles.speedControllerSlider, 'Value', 1);
        
    end
audioSpeedChanged = false;

%This function is used to merge two audio files into one single audio 
function mergeAudios(handles)

    global audioLoader1;
    global audioLoader2;
    global audioSound1;
    global audioSound2;
    global audioData1;
    global audioData2;

    if audioLoader1 && audioLoader2 
        
        if get(audioSound2, 'NumberOfChannels') == 1 
            audioData2temp = [audioData2 audioData2];
        else
            audioData2temp = audioData2;
        end
        
        if get(audioSound1, 'NumberOfChannels') == 1
            audioData1 = [audioData1 audioData1];
        end
        
        stopAudio(handles,1);
        stopAudio(handles,2);
        
        sampleData1=get(audioSound1,'TotalSamples');
        SRD1=get(audioSound1,'SampleRate');
   
        sampleData2=get(audioSound2,'TotalSamples');
    
        mergeTime=round(get(handles.mergeSlider,'value')) * SRD1; 

        if (sampleData2+mergeTime) > sampleData1 
            audioAddingTime = sampleData2+mergeTime-sampleData1; 
            supress = zeros(audioAddingTime,2); 
             audioData1 = [audioData1 ; supress];  
        end
    
        preAudioAdding = mergeTime; 
        preSupress = zeros(preAudioAdding,2); 
        
        if (sampleData2+mergeTime) < sampleData1 
        
            postAudioAdding = sampleData1 - mergeTime - sampleData2; 
            postSupress = zeros(postAudioAdding,2); 
            audioData2Manip = [preSupress ; audioData2temp ; postSupress];
            
        else 
            audioData2Manip = [preSupress ; audioData2temp];
            
        end
    
            audioData1 = audioData1 + audioData2Manip; 
            audioSound1 = audioplayer(audioData1,SRD1); 
    
            set(audioSound1,'TimerFcn',{@updateTimer,1, handles}, 'TimerPeriod', 0.1, 'StopFcn',{@audioEnd, 1, handles}); 
            updateGUI(audioData1,SRD1,handles,1); 
    
    end


    
%The below functions executes when a user performs actions on the buttons,
%sliders and checkboxes 

function varargout = sound_annotator_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function mainAudioImportButton_Callback(hObject, eventdata, handles)
loadFile(handles,1); %Load file function is called and the audio is loaded in the main audio player

function axes3_CreateFcn(hObject, eventdata, handles)
axesLabels(hObject); %axesLabel function is called which labels the axes of the main audio player

function axes3Slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function mainAudioPlayButton_Callback(hObject, eventdata, handles)
playAudio(1); %playAudio function is called here to play the audio in main audio player

function mainAudioPauseButton_Callback(hObject, eventdata, handles)
pauseAudio(1); %pauseAudio function is called here to pause the audio in main audio player


function mainAudioResumeButton_Callback(hObject, eventdata, handles)
playAudio(1); %playAudio function is called here to resume the audio in main audio player

function mainAudioStopButton_Callback(hObject, eventdata, handles)
stopAudio(handles,1); %stopAudio function is called here which stops the audio file from playin in the main audio player

function mainAudioSaveButton_Callback(hObject, eventdata, handles)
saveAudio(); % saveAudio function is called here to save the audio file into the system library

function mainAudioReverse_Callback(hObject, eventdata, handles)
reverseAudio(handles,1); %reverseAudio function is called here to reverse the audio file in main audio player

function mainAudioLoop_Callback(hObject, eventdata, handles)
playAudio(1); %Continuously plays the audio file unless the checkbox is unmarked

function resetButton_Callback(hObject, eventdata, handles)
speedRestoration(handles); %Restores the audio speed into the default speed

function speedControllerSlider_Callback(hObject, eventdata, handles)

addlistener(handles.speedControllerSlider,'Value','PostSet',@(s,e) set(handles.speedControllerLabel, 'String', round(handles.speedControllerSlider.Value, 1)));
speedManipulationRate(handles, get(handles.speedControllerSlider, 'Value')); 

function speedControllerSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function secondAudioImportButton_Callback(hObject, eventdata, handles)
loadFile(handles,2); %Load file function is called and the audio is loaded in the second audio player

function axes4_CreateFcn(hObject, eventdata, handles)
axesLabels(hObject); %sets the axes lables of the second audio player

function axes4Slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function secondAudioPlayButton_Callback(hObject, eventdata, handles)
playAudio(2); %playAudio function is called and the audio is played in the second audio player


function secondAudioPauseButton_Callback(hObject, eventdata, handles)
pauseAudio(2); %pauseAudio function is called and the audio is paused in the second audio player


function secondAudioResumeButton_Callback(hObject, eventdata, handles)
playAudio(2); %playAudio function is called and the audio is resumed in the second audio player

function secondAudioStopButton_Callback(hObject, eventdata, handles)
stopAudio(handles,2); %stopAudio function is called and the audio is stopped in the second audio player

function secondAudioLoop_Callback(hObject, eventdata, handles)
playAudio(2); %Continuously plays the audio file unless the checkbox is unmarked

function secondAudioReverse_Callback(hObject, eventdata, handles)
reverseAudio(handles,2); %reverseAudio function is called and the audio file is reversed

function secondAudioSaveButton_Callback(hObject, eventdata, handles)
saveAudio(); %Saves the audio file 

function mergeButton_Callback(hObject, eventdata, handles)
mergeAudios(handles); %mergeAudio file function has been called which merges the two audio file together

function mergeSlider_Callback(hObject, eventdata, handles)
addlistener(handles.mergeSlider,'Value','PostSet',@(s,e) set(handles.mergeTime, 'String', round(handles.mergeSlider.Value, 1)));


function mergeSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
