function varargout = AdaTempCreateTool(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @AdaTempCreateTool_OpeningFcn, ...
    'gui_OutputFcn',  @AdaTempCreateTool_OutputFcn, ...
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


% --- Executes just before AdaTempCreateTool is made visible.
function AdaTempCreateTool_OpeningFcn(hObject, eventdata, handles, varargin)
global tempName sampleSize stroke pointNum sampleInd tempInd drawing sampleNameCell
clc; dbstop if error;
xlim([0 2]); ylim([0 1]);
set(gca,'XTick',[],'YTick',[]);
set(gcf,'WindowButtonDownFcn',@mouseDown);
set(gcf,'WindowButtonMotionFcn',@mouseMove);
set(gcf,'WindowButtonUpFcn',@mouseUp);
stroke = 1;
pointNum = 0;
sampleInd = 1;
tempInd = 1;
drawing = 0;

% input dialogs
answer = inputdlg('How Many Samples Do You Want for Each Template?','Sample Size');
if isempty((cell2mat(answer)));
    answer = {'5'};
end
sampleSize = str2num(cell2mat(answer));

answer = inputdlg('name of your first template','Name Your Template');
while isempty((cell2mat(answer)));
    answer = inputdlg('name of your first template, you have to make an input!','Name Your Template');
end
tempName = cell2mat(answer);
sampleNameCell{tempInd,1} = tempName;
% Choose default command line output for AdaTempCreateTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AdaTempCreateTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AdaTempCreateTool_OutputFcn(hObject, eventdata, handles)


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in acceptButton.
function acceptButton_Callback(hObject, eventdata, handles)
global pointMtx sampleInd tempName tempInd sampleSize trainFeatureMtxCell ...
    thisFeatureCell sampleNameCell
% first get the features
thisFeature = ada_getFeatures(pointMtx);
pointMtx = [];
% add feature to the feature cell;
thisFeatureCell(:,sampleInd) = thisFeature;

if sampleInd == sampleSize;
    sampleInd = 1;
    trainFeatureMtxCell{tempInd,1} = thisFeatureCell;
    choice = questdlg('Do you have any other templates?', 'Keep Going?', 'Yes','No','Yes');
    switch choice
        case 'Yes'
            tempInd = tempInd + 1;
            text1 = ['name your ' , num2str(tempInd) , ' template'];
            answer = inputdlg(text1,'Name Your Template');
            while isempty((cell2mat(answer)));
                answer = inputdlg(text1,'Name Your Template');
            end
            tempName = cell2mat(answer);
            sampleNameCell{tempInd,1} = tempName;
        case 'No'
            choice2 = questdlg('Do You Want Do Adaboost Now?', 'Adaboost', 'Yes','No','Yes');
            switch choice2
                case 'Yes'
                    adaboostButton_Callback(hObject, eventdata, handles);
                case 'No'
                    
            end
    end
    
    
else
    sampleInd = sampleInd + 1;
end
% clear the screen and show the information;
discardButton_Callback(hObject, eventdata, handles);
info1 = num2str(tempInd);
info2 = [num2str(sampleInd-1) , '/',num2str(sampleSize)];
set(handles.tempNumDisp, 'String' , info1);
set(handles.tempNumDisp,'String' , info2);


% --- Executes on button press in discardButton.
function discardButton_Callback(hObject, eventdata, handles)
global stroke pointMtx
cla
stroke = 1;
pointMtx = [];

% --- Executes on button press in adaboostButton.
function adaboostButton_Callback(hObject, eventdata, handles)
disp('haha');
global trainFeatureMtxCell sampleNameCell
answer = inputdlg('Name of this sample set:','Name Your sample set');
answer = cell2mat(answer);
if isempty(answer);
    answer = 'temp';
end
name1 = [answer , '_sampleNameCell'];
save(name1,'sampleNameCell');
ada_trainingAdaBoost(answer, trainFeatureMtxCell);



function mouseUp(hObject, eventdata, handles)
xlim([0 1]); ylim([0 1]);
set(gca,'XTick',[],'YTick',[])
global drawing drawed pointNum stroke ;

if drawed;
    pointNum = 0;
    stroke = stroke+1;
end;

drawing = 0;
drawed = 0;
% disp('Size of point matrix');
% disp(size(pointMtx))
% pointMtx


function mouseDown(hObject, eventdata, handles)
% trainOrNot = get(handles.trainMode, 'Value');
global drawing stroke
xlim([0 1]); ylim([0 1]);
set(gca,'XTick',[],'YTick',[]);
drawing = 1;


function mouseMove(hObject, eventdata, handles)
global drawing pointNum drawed pointMtx stroke
xlim([0 1]); ylim([0 1]);
set(gca,'XTick',[],'YTick',[]);

currentPnt = get(gca,'CurrentPoint');
currentPnt = currentPnt(1,1:2);
if drawing==1 && currentPnt(1,1)<2 && currentPnt(1,1)>0 &&currentPnt(1,2)<1 && currentPnt(1,2)>0;
    pointNum = pointNum+1;
    pointMtx(pointNum,1:2, stroke) = currentPnt;
    % pointMtx(pointNum,3) = toc;
    forPlot = ada_removeZero(pointMtx(:,:,stroke));
    plot(forPlot(:,1) , forPlot(:,2) , 'b' , 'LineWidth' , 2);
    drawed = 1;
    hold on;
end;



