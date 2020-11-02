[~,g] = xlsread('Data.xlsx','Geometry');
[~,m] = xlsread('Data.xlsx','Mass-Inertia');
[~,t] = xlsread('Data.xlsx','Tire');
[~,s] = xlsread('Data.xlsx','Stiffness');
filename = 'Vorlage.xml';
DOMnode = xmlread('Vorlage.xml');
Parameter = DOMnode.getDocumentElement;

for i=1:length(g)
    read = strcat('A',mat2str(i),':E',mat2str(i));
    [data,name] = xlsread('Data.xlsx','Geometry',read);
    if isempty(data) && i<4 && length(name)==1
        file_name=name;
    elseif isempty(data) && i>4 && length(name)==1
        xmlwrite(strcat(char(file_name),'.xml'),DOMnode);
        DOMnode = xmlread('Vorlage.xml');
        Parameter = DOMnode.getDocumentElement;
        file_name=name;
    elseif isempty(data) && length(name)>1
        trash = 0;
    elseif isempty(data)==0
        vectorPar = DOMnode.createElement('vectorParameter');
        vectorPar.setAttribute('name',char(name));
        xmlVec = DOMnode.createElement('xmlVector');
        for j=1:length(data)
            ele = DOMnode.createElement('ele');
            ele.appendChild(DOMnode.createTextNode(sprintf('%f',data(j))));
            xmlVec.appendChild(ele);
        end
        vectorPar.appendChild(xmlVec);
        Parameter.appendChild(vectorPar);
    else
        trash=0;        
    end
end
xmlwrite(strcat(char(file_name),'.xml'),DOMnode);

for i=1:length(m)
    read = strcat('A',mat2str(i),':K',mat2str(i));
    [data,name] = xlsread('Data.xlsx','Mass-Inertia',read);
    if isempty(data) && i<4 && length(name)==1
        file_name=name;
        DOMnode = xmlread(strcat(char(file_name),'.xml'));
        Parameter = DOMnode.getDocumentElement;
    elseif isempty(data) && i>4 && length(name)==1
        xmlwrite(strcat(char(file_name),'.xml'),DOMnode);
        file_name=name;
        DOMnode = xmlread(strcat(char(file_name),'.xml'));
        Parameter = DOMnode.getDocumentElement;
    elseif isempty(data) && length(name)>1
        trash = 0;        
    elseif isempty(data)==0 && isempty(name)==0
        if length(data)==1
            scalarPar = DOMnode.createElement('scalarParameter');
            scalarPar.setAttribute('name',char(name));
            scalarPar.appendChild(DOMnode.createTextNode(sprintf('%f',data(1))));
            Parameter.appendChild(scalarPar);
        else
            matrixPar = DOMnode.createElement('matrixParameter');
            matrixPar.setAttribute('name',char(name));
            xmlMat = DOMnode.createElement('xmlMatrix');
            for j=[0,3,6]
                row = DOMnode.createElement('row');
                for k=1:3
                    ele = DOMnode.createElement('ele');
                    ele.appendChild(DOMnode.createTextNode(sprintf('%f',data(j+k))));
                    row.appendChild(ele);
                end
                xmlMat.appendChild(row);
            end
            matrixPar.appendChild(xmlMat);
            Parameter.appendChild(matrixPar);           
        end
    else
        trash=0;
    end
end
xmlwrite(strcat(char(file_name),'.xml'),DOMnode);

for i=1:length(t)
    read = strcat('A',mat2str(i),':B',mat2str(i));
    [data,name] = xlsread('Data.xlsx','Tire',read);
    if isempty(data) && i<4 && length(name)==1
        file_name=name;
        DOMnode = xmlread(strcat(char(file_name),'.xml'));
        Parameter = DOMnode.getDocumentElement;
    elseif isempty(data) && i>4 && length(name)==1
        xmlwrite(strcat(char(file_name),'.xml'),DOMnode);
        file_name=name;
        DOMnode = xmlread(strcat(char(file_name),'.xml'));
        Parameter = DOMnode.getDocumentElement;
    elseif isempty(data) && length(name)>1
        trash = 0;        
    elseif isempty(data)==0
        scalarPar = DOMnode.createElement('scalarParameter');
        scalarPar.setAttribute('name',char(name));
        scalarPar.appendChild(DOMnode.createTextNode(sprintf('%f',data(1))));
        Parameter.appendChild(scalarPar);
    else
        trash=0;
    end
end
xmlwrite(strcat(char(file_name),'.xml'),DOMnode);

for i=1:length(s)
    read = strcat('A',mat2str(i),':C',mat2str(i));
    [data,name] = xlsread('Data.xlsx','Stiffness',read);
    if isempty(data) && i<4 && length(name)==1
        file_name=name;
        DOMnode = xmlread(strcat(char(file_name),'.xml'));
        Parameter = DOMnode.getDocumentElement;
    elseif isempty(data) && i>4 && length(name)==1
        xmlwrite(strcat(char(file_name),'.xml'),DOMnode);
        file_name=name;
        DOMnode = xmlread(strcat(char(file_name),'.xml'));
        Parameter = DOMnode.getDocumentElement;
    elseif isempty(data) && length(name)>1
        trash = 0;        
    elseif isempty(data)==0
        vectorPar = DOMnode.createElement('vectorParameter');
        vectorPar.setAttribute('name',char(name));
        xmlVec = DOMnode.createElement('xmlVector');
        for j=1:length(data)
            ele = DOMnode.createElement('ele');
            ele.appendChild(DOMnode.createTextNode(sprintf('%f',data(j))));
            xmlVec.appendChild(ele);
        end
        vectorPar.appendChild(xmlVec);
        Parameter.appendChild(vectorPar);
    else
        trash=0;        
    end
end
xmlwrite(strcat(char(file_name),'.xml'),DOMnode);

filename = 'Vorlage.xml';
DOMnode = xmlread('Vorlage.xml');
Parameter = DOMnode.getDocumentElement;
for i=1:length(m)
    read = strcat('A',mat2str(i),':K',mat2str(i));
    [data,name] = xlsread('Data.xlsx','Mass-Inertia',read);
    if isempty(data)==0 && isempty(name)==0
        if length(data)==1
            scalarPar = DOMnode.createElement('scalarParameter');
            scalarPar.setAttribute('name',char(name));
            scalarPar.appendChild(DOMnode.createTextNode(sprintf('%f',data(1))));
            Parameter.appendChild(scalarPar);
        else
        trash = 0;
        end
    else
        trash = 0;
    end
end
xmlwrite('kinematic_check.xml',DOMnode);