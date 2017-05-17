(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �7Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[���1HB�u��	7�'��ʍ��4��|
�4M�(M"�w���(B#8��E:�c�F~Nsc����V��N��4{��k��P����~�MC{9=��i��>dD\.�&�J�e�5�ߦ��2.�?�]ɿ�Y��7�T��%	���P�w{�{�h�\�Z��r�K���l��+�r��4MT�/��5��N�;�����q0Ew�~z-�=�h, (J�ԗZ���w�O�x��r���C�1�Fhsp�<��)�r	�i�)�!	�\�(!�i�d0�v<�tQ�	�&���W��(C���O/��D���¾Ԑ2:���WGpbCVk"/�A���&0�Z[�Ny��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��wG�����o{�t���������Q��_)�(��e\?^'~����������@*�_
�^�Y��Bm�j~Y����\�@(k�R�Y��2C�gͥ�m-��0\M�nO�0�BE�r��,�Դ�����A4��F �<��5L���x�Fdb�P�S�S�&mdq���!9�G��9����'��6̅;g�ヸ��B��b�Mn1�zn���A�!⊠���z�ŌG�!i�^=ܧ� v0?�`����Сs͡��Չ�XD���Cq'������Y�M��I[,��oā�q�t1�S�b>��Cso୥bpc�S��L� O
�>
p�����yxsh���H"S�n$L�^�[\c�ƨ��s��/;hS@�N��䒡ʅ�ʻ�R�L�ŭ�L�f�E�F�S q|~O�E�5�(�dz�>h���@���{p+O<��p `��Q�:��xY���"cR��M����� ��z`m:�������}�\)L�B�<@B��^�x�:tr �	>��-�F\Ę�2�`���>;��ߵs9䖓�%���D�b�ՇL�@�"=�cш�̢O�Q��>,>0����{f��_���4|����Q���R�A����x��ѧ���U�x���Y��Nt��:PC��f{��W�d�%��'�s>��v<�3�H'B�~Ĩ�*�#F};��rd��A��`� �EZ��`����4E�w���7��0EWrH<�0��'�5�%��;�b��V.�S^S�Q���lM�HM\L���C�f�ߛe�.�i���ռ���ž�@h]�.?���gN�ȅ�D�=�5af[8�ȑ�[���9k@@H\^d��!��
 y;?U2�x-�cb��a�59p�k9�;�u]�����f�ڔ�Q"��0~:h=��E�Fѥ>��6s0!����8N�H�YD��M��_��~a(�v�7�6cyb|�M����u-�WS�ͬ��C��db<�?�/��~����?$Y�����Ϝ�/����.�����������s�_��o�	�����������?3����JA�S�����'}�p�/�l��:N�l��a��a���]sY��(?pQ2@1g=ҫ��.�!�W�����E������vO��M
Zy8�XOP�Yǳ�>Wx�qpa��Q��Ë�?k�؂m�
f�dܐ����[&_z˖2�'�!rXm|�1�>��:ݎ,h��ܘ��%���_�[P�	v��lO�*��������?d�_
>J���V��T���_��W���K�b�O���|���H�O�������L���7s(<:��P�қ�]���O������.:6K}o������`p�{�i2����U�>2�2<�$�zo*ͭ��3A>���w���]����t�x�͆�f2o�z�D���D!P����]�p�r'�v�ó@�D�s�m�ȸ��IG�^p ?G��qڠy��)�8�9@z��%�i�V��ڹN�M�|��6Y��.,����μ����´gOM��@�$0A����^��Y��h1	�x�� ��i��=SZ������SMG��v"FR>�9K����Ё��yW 'Y1�������)~I�f�V���F�O������+�����\{���ߵ�}����"h������B�/�b�����T�_���.���(��@�"�����%��16���ӏ:��O8C������빁[�8�(���H��>��,IRv�����_���]�e���?�	�"�Z�T��csbkL�6��s�U�����Г��b�J }'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߻�x�ǩ�~���?J��9x���'���w��P�����B�߾�L)\.����_
�+���o_V�˟.�T�/)����^,E�j�o)���b�?Y�!i�Z�)�2�Y���ň��ǶI��)�B]�B<�`Y�����w]7��%� p|�eX��JC�|�G��?U�?�������Aj�h�(��P�A����0�.���]#M���/���4���v]wW����s)���aDn5f����Q�5#���n��������j=qMP��	ff�^���9�_�����*����JO�?
�+��|���}i�P�2Q��_����b�c�O X�������1��㿟��9+9�Vᯱ�% ��7�g�?�g}��$������7����*-û���֍��{�� �7�ݰ����s��Mk?lڹe�@��S���)�b^<�]h�i���Mb�ڷ�M�	l#ע�iV��X�g�����z�N��7o�(6W3����V\4�ߛ��
�[g���|�G�-ãe�q�#=�$l��v�$�\h���@8ǻ5u�\�(R�&���t�*�)�sj�N%��ǆĭ�0����@ u�3"�mo�ey����A�Ě@�D0�ljN�����|sO���F���4�r�Yf<%���?m{�ȡ��<wJl���'�M�V������Z���"k�JC�y�`��_����+����?�W��߄ϙ�?ȭ܀�e��U����O%���K�������� ���5��͝dv�
9���D����P�'������7��6��u���>�=n�C�j
��k���m����=8"1��C�MIiK[TwDck6�^�͵F߲���m{���L�ص4�aH���dNS�28�PеDr��8�I�� ��B��<���]j�?6�Y�|�9���f-x6���nڷW�`�5��\��^J�r��{���,�C��z}��{���46a�Dw�h�"���������_:�r���*����?�,����S>c�W����!��������?����_��W��o���:�b�ð�������ܺ���1
����RP��������[��P�������J���Ox�M���(�8�.C�F��O�L�8��C�O��#��b��`xu
�o�2�������_H�Z�)��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��{����O��%q�_�������-f���_�~��l�4+����_�_���v���W�Vsm�x�զ��_k�}�����N:u�\�뎡n(�
�F��+{�L��w��v����_�ϕ�jW5	p������U�o��v��zul�������:�^ǿh�$�_�uJ+nd/���lR�rk=��v�vU�\W+��¯�z�'�}_�8W4�����'�ծ��i����k��U��N]�����G��%��}}�S���rmO�~z���bT���]ePQ��V�9O��2�n�]4��� �~�UQ����7D�.��ߐ�ӿK�}���F�+|;��������>w�z��8N����Q��E�g_nl��ߓ�o�����d�y�,�3�^����o���:b��"{�a�%o�� ��w[/��������i]��Wv7�~Z���<���ϫ��g￟��c��?m�\T{X����q:�.�o�~��q���8��8K]8��'�PY?�n��v��&>ф�D����8���S�n�>*��~~ˇ#������NY��c������	d��
�8��!�"v�7�h�<.��#��:����M��3B�+�Ʒ�r��
��$����N�t��ϖ�u�p������q�*����vz.���b��m�-�����|8J'N2��8��R��8��ĉ=v�+�B*�b�?��
�� �� ?vQ+��C]!���� ��ēL���tz[�ϕ�8�{>|���y��9�X93Q��дoo�,6��Y�\�ܒ[@		���C!x�J��D,C����l�"k,��%2���X2JBk[׎�N�$�@l}a�/�������L�iQbѭ� l�Q Z�kB�1���g1�9'�p�	�B���ʢ��*�:���2�n��k�&�K��jM<4åv�L4�h �WG�0��K��#[F�v5�&�F㱩J��3u��ifX=��ߑ4�����s��A[ȗ�Y�����i	���X�{J���"Ι7��}0���37�UY=4��H�-����g�u�h[��F����[(��KSƪ�&jb�f܂�}s�5ESl=�bol4]�!�[4]h�p��N�fr�ԁӳ�i`	N��8��"8����i��N������u;�~SS�����NmUo?Jx����Z�F�5wY�='�t����4�I��8Q��]O؝��}�r��]vD��錮�/��	(#+�[���}����Q��hzC3�0�]梭,�>���u���>�|�T�Wr��c��öh?�1�.܄"7��V5JS�Q�ot��p�gI���-qAhIf�r��ӑkG�z!_OW�fK�&@���(���{E�9��RC���'i��~,IA�HDL���,!�V�C��2c�V�mI�2��޴.�D�[�&����a�;�؇��&���Vu�vagk��]G�#Xwu�܂.�`U�᧳O+xh6oEt�����4���Xw�j�q��/n��������s����	�"	���;��~��O}�.�=�J�xr�{����`
�!����z0�{�}?/�!�����8*�����pf�\4�w��ۻ/=t����ԃ�ܿ]x���?�/����"�`��8�t�s�]7�{G��F~�0 �qq䅇w�q��<|��k��-\���H�a���>;��~ /�JKF�9��ln����A\Rl^��Āͷ)s�uNZ<�$K��D!�� #�w~[���!r}ذ��	�z;�*P����z��W�vKh��h�W�b��~v�	�.�.a�AUZD +�u���Q�.��E��5����>g��%X�b��(���9��-\��T�o��`B��u4> dCf�<���p6̓3�U������e)���GC-��͔%�R*U_��/)٪e���L�#%��o��p�@���W�u���bD�����д�߬D2�����}ȗ/9LX�	�0a7a�"_>a�#&�2�"ltnSO�������蚟�R3B�`啕���#J	|#�mh����_'=�t(�V��Th�*4�*:4��?���\/i\�;���hO�i9��-o��Rh�q�鐕��=.�e���a��tc9�������G�d��
�����vQz�C{e2��:m��F1��F�����L �扆�'Qh9N�
�^k(��}��m��Mv?�,QjI��8�ی�;v�W_Y��,k6`]P�=on���]�$�Ψ`<
zS-�rű��
/9���=j��c�a-R��LGn3�R��=|��1��6���>s:e!9�-e����R��e\��u�̒�^�]�,q�GF�!��i��	�S��P� �Ӌ�ռ/�l�2�Y�2���A\Ç�=,�3�X#��\�8(���@"%��F��k�,�U�2\�,�㕥������@��ܫ	E���AH)Faxj�MK���.�?Բ��!Kc��QR��ս�B75�U�|�%��(�PZx
�)��%*�Jb#���� �qO6W8lIY�/ȮU.����B��zc�J]B��(���F��)��ϧ�l�C�8q���*=4ںХ�b�Wj��r,���j���t���S��9>��m��\"̀�����%��uyrm�Nd�B.����ع��y�U����#�₲o�˳�\�ϳ}�|UY������w�7��� �!v��E�G�wy���a�<�P�h}ʨJC! ���HA�.�(��;��IL!+]�a}�0�������c��H�m��h��j���=Vkr��������y����g�qٷ�;�*re�M��޾`�� ��M
`�W5���[�{��=��+��6[fzb^f�ו�|�:�Lj�I��_G~���+ҏ����@G�U��xf n�* �.+���lpv�m"hw�G�D^����~������`㗂�N�'���Mi�\�O��T�؉��|{����s_x�VGJfmu4��'����`<���y�W�.8X9����� g]pp�*`y�͚3��@���"%��m�Pho��*�a���>>�1^	�q.����T+8�:I,�b`iB���Ra�_�(��p�"^��m�ɦ�h���K�,U�L��ā��$3`�� ��KY�>����,i�ff8T"�H5��àGŽ�d.>> �f'5&X�Q��V��t +�Ǆ"=��jcG�e��>��zO��4�bkw<c��� !�;��G3�^�p�u�%�� ��c5�W[�Fy�M����v��1�8N�c=�^�#�۠S��9���M��3�i����=�<��p/r��p���<,��w��O̎��?<q���-�I{�D�6Drs��U���X�E�B��7	??"��D����<Z��MR�Eȅ��,&���
L�"�͚����x�X��3X�pz[KrF;H�:��±t���n��'�q�����\�W=!�dU��h+b0^_�T��8:q4[�(�����|0�h,�6r�J��"
���@H�_i�ݸ�@@{8��
Xܓ*��.jC|���"��A�*w�1)��u����iQ����s)���A���[�SK��otܐS{
�< ��iѨ6+�X��O��F�BK�.������co�q*�ǻ���)��)[ȱA�k���a����A+l�|�7�FG�u�����V�p�/0�7'�=�h���.�h�^�ܻ��ů��i��"���6� [�R.Nz���n�+�,�Q�&��q���a��7�����G~��^�g�c��������c/���?�����������9i1���~�u�����G�����mI�����W��[O��w��?�0r��'�<�����2�5�;�/"��_J�/&A<�u���[?������1�NԨ!;���%?t�����G[����ݾ?��������<��� �b�_�Q;�F^^�v�ҡv:�N������C�t��޿�:i' �P;j�C�t|6�g{=P;Oͷ��|�� UnB���zX䂦��h o[E�e<b��[ϙ:�c�?��?�yi��������8�R�O���1�8^3��8�g`�2��|�47�f���̙q��ΜgZ�3-��3��c�a�����a
�혙s��p��mJ�|uɣ�H�</~��A[���?'9�INr��6�Gj�  