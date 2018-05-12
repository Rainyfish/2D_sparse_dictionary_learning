function addToxls(rt_data_dir)

fprintf('dir the database...');
subfolders = dir(rt_data_dir);

database = [];
database.cname = {}; % name of each class
database.path = {}; % contain the pathes for each image of each class
for ii = 1:length(subfolders)
    subname = subfolders(ii).name;
    if ~strcmp(subname, '.') & ~strcmp(subname, '..')         
        database.cname{ii} = subname;
        frames = (fullfile(rt_data_dir, subname));
        database.path{ii} =frames;
        load(frames,'opts');
        if(isfield(opts,'acc'))
            s(ii,1).lambda = opts.lambda;
            s(ii,1).rank_lambda = opts.rank_lambda;
            s(ii,1).gamma = opts.gamma;            
            s(ii,1).left_dictionary_size = opts.dict_size(1:2);
            s(ii,1).right_dictionary_size =  opts.dict_size(3:4);
            s(ii,1).miu = opts.miu;
            s(ii,1).threshold = opts.threshold;
            s(ii,1).acc = opts.acc;
            s(ii,1).path = frames;
        end
        
    end
end;
T = struct2table(s);
writetable(T,'1.xls');
disp('done!');

end
