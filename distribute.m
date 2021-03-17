function out=distribute(varargin)
%A=[1,5,6,9,12];
%B= [1,2,3,4,5,6];
%C= [3,18,27,69,72];
%D= [3,18,27,69,72];
% distribute(A,B,C,D)
%
%A=[1,5,6,9,12];
%B= [0,0,0,0,0,0];
%C= [0,0,0,0,0];
%D= [0,0,0,0,0];
%distribute(A,B,C,D)
%
% S={'DNW','JDB','SHK'};
% E={'1D','2D'};
% P=1:2;
% K='EXP';
% distribute(S,E,P,K)

    in=varargin;
    cellind=cellfun(@iscell, varargin);
    if sum(cellind)>0
        in(cellind)=cellfun(@(x) ([1:length(x)]),varargin(cellind),'UniformOutput',0);
    end

    charind=cellfun(@ischar, varargin);
    if sum(charind)>0
        in(charind)={1};
    end

    if nargin == 2
        out=distribute2(in{:});
    else
        out=distributeN(in{:});
    end

    if sum(cellind)>0
        out=convertback(out,varargin,cellind,charind);
    end
end
function out=convertback(out,orig,cellind,charind)
    ind=out;
    out=num2cell(out);
    N=find(cellind);

    % by column
    for i = N
        I=ind(:,i);
        v=transpose(orig{i});
        out(:,i)=v(I);
    end

    N=find(charind);
    for i = N
        I=ind(:,i);
        v=orig(i);
        out(:,i)=v;
    end
end

function out=distributeN(varargin)
    p=perms([1:nargin]);
    nP=size(p,1);

    grids=cell(nargin,1);
    [grids{:}]=ndgrid(varargin{:});
    nG=length(grids); %num dimentions

    N=nG*nP;

    K=distribute(1:nG,1:size(nP,1));

    for k = 1:size(K,1)
        i=K(k,1);
        j=K(k,2);

        t=permute(grids{i},p(j,:));
        out{k}=t(:);
    end
    out=horzcat(out{:});
end

function C = distribute2(A,B)
    % function C = distribute(A,B)
    % distribute elements between vectors
    % Useful for expanding indices
    % example call:
    %           distribute([3 2 1], [4 5 6])
    % CREATED BY DAVID WHITE

    %INIT
    if size(A,2)>1 && size(A,1)==1
        A=A';
    end

    if size(B,2)>1 && size(B,1)==1
        B=B';
    end

    %DISTRIBUTE
    C=repelem(A,size(B,1),1);
    D=repmat(B,size(A,1),1);
    %C=repelem(A,numel(B));
    %D=repmat(B,numel(A),1);
    if ~isequal(size(C,1),size(D,1))
        C=C';
    end

    C=[C D];
end
