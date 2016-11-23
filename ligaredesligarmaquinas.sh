#!/bin/bash
IPMAC=IpMac.txt
ESTADO=
MAC=

function listIpOn(){
   ARQUIVO=IP.txt
   
   IP=$(dialog --stdout \
               --menu "$1"\
                250 250 $(cat $ARQUIVO | wc -l) $(cat $ARQUIVO)   
   )       
   echo $IP
}

function ligarComputador(){
    dialog --title "TRABALHO SHELL SCRIPTING" --textbox "$1" 250 250\
    --and-widget\
    --yesno "Você Quer realmente Ligar $2 ??" 250 250
}

function desligarComputador(){    
    dialog --title "TRABALHO SHELL SCRIPTING" --textbox "$1" 250 250\
    --and-widget\
    --yesno "Você Quer realmente Desligar O $2 ??" 250 250
}



function selectionOPtion(){
   proxima=primeira
   
   while true ; do

  case "$proxima" in
         primeira)
            proxima=segunda
            dialog --backtitle 'OPÇÕES DISPONIVEIS'\
                   --msgbox 'Bem-Vindo ao gerenciador de estado das máquinas' 0 0
         ;;

         segunda)
            opcao=$(dialog --stdout --backtitle 'LIGAR DESLIGAR MÁQUINAS'\
                             --menu 'Menu de opções' 0 0 0\
                             'Máquinas Laboratório' ''\
                             'Alterar Estado' '' \
                             'Sair ........'  ''              
             )  

            case $? in
                  1)            
                    proxima=final
                  ;;

                  0)
                      case $opcao in
                           "Máquinas Laboratório")
                                      proxima=terceira    
                            ;;
                           "Alterar Estado")
                                     proxima=quarta
                           ;;
                           "Sair ........")
                                     proxima=final
                           ;;
      
                      esac
                  ;;

            esac

           ;;

          terceira)           
               proxima=segunda          
               listIpOn 'Status Ligada ( ON ) Desligada ( OFF ).' &> /dev/null
           ;;

          quarta)   
               proxima=segunda
               IP=$(listIpOn "Para Modificar O Estado Selecione Uma Máquina, Em Seguida Click Em [OK].")
              

          	 case $IP in
			d0:27:88:c1:f0:03)
                	  ligarComputador $1 $IP
                 	  case $? in
                         	  0)
                            	  proxima=quarta
                            	  wakeonlan $IP  &> /dev/null
                           	   sleep 3
                          	 ;;
   
                           	1)
                            	  proxima=quarta   
                          	 ;;
                   	   esac
			;;

		    d0:27:88:c1:d3:2f)
                  		ligarComputador $1 $IP
                  		 case $? in
                           		0)
                            	 	 proxima=quarta
                             		 wakeonlan $IP &> /dev/null
                            	 	 sleep 3
                             		  ;;
   
                         		1)
                              		proxima=quarta   
                         	  	;;
                        	 esac

		    ;;
	
                   200.129.39.94)
                 	 desligarComputador $1 $IP                        
                 		case $? in
                           		0)
                             		proxima=quarta
 					ssh tarc@$IP sudo init 0 &> /dev/null
				      
                             		 
                          	  	 ;;
   
                          		 1)
                             		 proxima=quarta   
                               	   	 ;;
                              	 esac

	       		;;
	 	 200.129.39.69)
                 	 desligarComputador $1 $IP                               
                 		case $? in
                           		0)
                             		proxima=quarta
 					ssh tarc@$IP sudo init 0 &> /dev/null
                          	   ;;
   
                          	 1)
                             	 proxima=quarta   
                                   ;;
                               esac
             
             	 ;;
	
		esac
 	;;
             final)
                 
                    dialog --stdout --title "EXIT"\
                           --yesno "Você deseja realmente sair ??" 0 0
                     
                    case $? in
                           1) 
                           proxima=segunda
                           ;;
   
                           0)
                              sleep 3 
                              clear                              
                              exit 1
                           ;;
                    esac
                   
             ;;
         esac   
   done
}     

selectionOPtion IP.txt
