function mdc = meandistconf(A, B)

%{
by Daniel Alexander, 2021

INPUTS:

A,B     - binary masks, each size mxn

OUTPUTS:

mdc     - mean distance to conformity metric, scalar

PLEASE NOTE: the use of parallel for loops will increase the speed of this
execution, but may be slower the first time you run it.

%}

    if ~isequal(size(A), size(B))
        disp('Error: arrays must have equal size')
        return
    else
        % convert arrays to logical
        A = logical(A);
        B = logical(B);
        
        % Initialize set arrays
        C1 = zeros(size(A));
        C2 = zeros(size(B));
        D = zeros(size(A));
        
        % Determine disagreement sets
        C1(A~=0 & A~=B) = 1; % all points in A that are not in B
        C2(B~=0 & B~=A) = 1; % all points in B that are not in A
        C = C1 + C2; % sum

        % Determine agreement sets
        D(A==B & A~=0) = 1; % all points in A and B

        % Find x and y coordinates 
        [r1,c1] = find(C); % (y,x) for all disagreement points
        [r2,c2] = find(D); % (y,x) for all agreement points

        % Create arrays of data points (agreement) and query points
        % (disagreement)
        P = [r2, c2]; % data points
        PQ = [r1, c1]; % query points
        
        % Calculate MDC
        dists = zeros(size(PQ,1),1); % initialize array of distances for each query point
        parfor i=1:size(PQ,1)
            temp = sqrt(sum((P-PQ(i,:)).^2,2));
            dists(i) = min(temp(:));
        end
        mdc = mean(dists(:));
     
    end
end

%{
note, I tried to use dsearchn instead of this loop, but it was slower. :(
%}
   