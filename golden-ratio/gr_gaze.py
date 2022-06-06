#Saleh Mozafari - saleh.mozafari@dfki.de
# The Golden Ration Eye Tracking Project
# German Research Center for Artificial Intelligence (DFKI GmbH), Kaiserslautern

# **************************************************************************
import numpy as np
import math
import csv
# **************************************************************************
# Classes ******************************************************************
class gaze_info():
    
    def __init__(self, file_name):
        self._text = open(file_name,'r')
        
    def convert_to_array(self): 
        # frm: the Frame Number; x: X coordinate; y: Y coordinate; f: Fixation; 
        # xcf: X Coordinate of Fixation Centroid;  ycf: Y Coordinate of Fixation Centroid; 
        # fd: Fixation Duration; nw: Nearest Word; d: Retrieved Document
        
        arr = np.genfromtxt(self._text, dtype=None,  
                                  delimiter = '\t', names = ('frm', 'x', 'y', 'f', 'xcf', 'ycf', 'fd', 'nw', 'd'))
       
        dim = np.shape(arr)
        return dim[0], arr 
    
    def split_parameters(self, fix_lst):
        x = list()
        y = list()
        d = list()
        xy = list()
        for i in fix_lst:
            x.append(i[1])
            y.append(i[2])
            d.append(i[3])
            xy.append((i[1],i[2]))
        return xy, x, y, d    
       
    def fixations(self, dim, arr):
        # To collect fixation blocks
        # initiation of variables
        fixation_block = 0
        flag = 0
        total = 0
        # f_index = 0
        fixation_list = list();
        for i in np.nditer(arr):
            total += 1
            if flag == 0:
                if i['f'] == 'Fixation':
                    fixation_block += 1
                    fixation_list.append([fixation_block, i['xcf'].tolist(),i['ycf'].tolist(), i['fd'].tolist(), i['d'].tolist()])
                    flag = 1 
                    
                else:
                    continue
            else:
                if i['f'] == 'Fixation':
                    fixation_list.append([fixation_block, i['xcf'].tolist(),i['ycf'].tolist(), i['fd'].tolist(), i['d'].tolist()])
                else:
                    flag = 0

        return self.centroid(fixation_list, fixation_block)            
    
    
    def centroid(self, f_list, f_size):
        # Calculate of center of each fixation
        average_list = list()
        i ,j , x_mean,  y_mean, duration = 0, 1, 0, 0, 0
        
        for lst in f_list:    
             
            while j <= f_size:
            
                if lst[0] == j:
                    i += 1
                    x_mean += lst[1]
                    y_mean += lst[2]
                    duration = lst[3] 
                    break
                       
                else:
                    if i != 0:
                        x_mean /= i
                        y_mean /= i
                        x_mean = int(round(x_mean))
                        y_mean = int(round(y_mean))
                        average_list.append([j, x_mean, y_mean, duration])
                        i , x_mean,  y_mean, duration = 0, 0, 0, 0
                        j +=1
                        
        x_mean /= i
        x_mean = int(round(x_mean))
        y_mean /= i
        y_mean = int(round(y_mean))
        average_list.append([j, x_mean, y_mean, duration])
                
        
        XY, X, Y, D = self.split_parameters(average_list) 
        
        S = self.saccades(XY, f_size) 
        R = self.regression(X, f_size)       
        return XY, X, Y, D, S, R, f_size        
             
    
    def saccades(self,xy, f_size):
        i = 0
        saccad = list()
        while i < (f_size-1):
            sac = round(math.sqrt(((xy[i][0]-xy[i+1][0])**2) + ((xy[i][1]-xy[i+1][1])**2)), 2)
            saccad.append(sac)
            i += 1
        saccad.append(0)
        return saccad 
    
    def regression(self, x, f_size): 
        i = 0
        regression = list()
        while i < (f_size-1):
            val = x[i+1]-x[i]
            if val < 0:
                regression.append(1)
            else:
                regression.append(0)    
            i += 1
        regression.append(0)
        return regression
    
    def export_to_csv(self, gaze, name):
        
        
        fields = ['x_coordinate', 'y_coordinate', 'fixation_duration', 'saccades', 'regressions']    
        name = name[:-3] + 'csv'
        gaze_file = open(name,'wb')   
        csvwriter = csv.DictWriter(gaze_file, delimiter=',', fieldnames=fields)
        csvwriter.writerow(dict((fn,fn) for fn in fields))
        for row in gaze:
            csvwriter.writerow(row)
        gaze_file.close()
        
    def offset_finder(self, gaze): 
        i = 0
        my_first_gaze = gaze[0]
        x_start = my_first_gaze['x_coordinate']
        y_start = my_first_gaze['y_coordinate']   
        x_offset = 200 - x_start
        y_offset = 200 - y_start
        
        while i<len(gaze):
            gaze[i]['x_coordinate'] = gaze[i]['x_coordinate'] + 100
            gaze[i]['y_coordinate'] = gaze[i]['y_coordinate'] 
            i += 1
            
        return gaze
        
# **************************************************************************
def main():
    
    i = 0
    gaze_data = []
    filename = 'P11-2.txt'
    dfki = gaze_info(filename)
    dim, gaze_arr = dfki.convert_to_array()
    xy, x, y, f_duration, saccades, regressions, n_fixations = dfki.fixations(dim, gaze_arr)
    
    while i < n_fixations: 
        if x[i] > 0: # Cleaning the noises (negative coordinates indicate the noise)
            gaze_data.append({'x_coordinate': x[i], 
                          'y_coordinate': y[i],
                          'fixation_duration': f_duration[i], 
                          'saccades': saccades[i], 
                          'regressions': regressions[i]})
        i += 1
        

     


    gaze_data = dfki.offset_finder(gaze_data)
    
    dfki.export_to_csv(gaze_data, filename) 
    
    print('done ...')
    '''
    writer = csv.writer(open('dict.csv', 'wb'))
    for key, value in gaze_data.items():
        writer.writerow([key, value])
    '''

     
if __name__ == "__main__":  main()
