CR    ����0&  f  default App({
    page: "pages/page1/page1",

    /* app 加载完成触发该函数 */
    onLaunch: function (e) {

    },

    onShow: function (e) {

    },

    onHide: function () {

    },

    /* app 退出触发该函数 */
    onExit: function () {

    },

});
  {
    "id"     : "com.example.ART_Badge_template",
    "name"   : "@app_name",
    "author" : "rt-thread",
    "vendor" : "rt-thread",
    "version": "v1.0.0",
    "tag":[ "app" ],
    "apiLevel": {
        "min": 3, 
        "target": 3
    },
    "icon"  : "app.png"
}
 /*****************************************************
** 文 件 名： touch.js
** 内容简述：设置默认 js 代码
** 创建日期：2020-12-13 12:35:28
** 修改记录：
    日期    版本      修改人     修改内容
2020-12-13 1.0.0 LAPTOP-T79B2D91 设置默认 js 代码
******************************************************/
module.exports = {
    TouchMode : {
        cancel: 0,
        press: 1, // 长按
        move: 2,  // 移动
    },

    PageTouchInit : function (page) {
        page.touchStartY = 0;// panel中触摸的Y坐标
        page.touchStartPosition = 0;// page中开始触摸的坐标
        page.touchEndPosition = 0;// page中结束触摸的坐标
        page.touchStatus = this.TouchMode.cancel;
        page.touchTimer = 0;
        page.navigateEnable = true;
    },

    PageTouchUninit : function (page) {
        var that = page;
        if (that.touchTimer != 0) {
            clearInterval(that.touchTimer);
            that.touchTimer = 0;
        }
    },

    PageTouchEvent : function (page, event, longPress, R2L, L2R, T2D, D2T) {
        var that = page;
        var touchItem = event.touchs[0];

        if (touchItem.type == "touchstart") {
            //console.log(" >>> touchStart")
            /**长按操作**/
            that.touchStatus = this.TouchMode.press;
            that.touchStartPosition = { x: touchItem.x, y: touchItem.y };
            //console.log("that.touchTimer: ", that.touchTimer);
            if (that.touchTimer != 0) {
                clearInterval(that.touchTimer);
                that.touchTimer = 0;
            }

            that.touchTimer = setTimeout(function () {
                //console.log(">> long press");
                clearInterval(that.touchTimer);
                that.touchTimer = 0;
                if (that.touchStatus == this.TouchMode.press) {
                    if (typeof (longPress) == "function") {
                        longPress();
                    }
                }
            }, 1000);

        } else if (touchItem.type == "touchmove") {
            //console.log(" >>> touch move")
            that.touchStatus = this.TouchMode.move;
            that.touchEndPosition = { x: touchItem.x, y: touchItem.y };
        } else if (touchItem.type == "touchend") {
            console.log(" >>> touch end")
            if (that.touchStatus == this.TouchMode.move) {
                var d_ValueX = that.touchEndPosition.x - that.touchStartPosition.x
                var d_ValueY = that.touchEndPosition.y - that.touchStartPosition.y
                // console.log(" x : " + d_ValueX);
                // console.log(" y : " + d_ValueY);
                // console.log("  that.navigateEnable : " +  that.navigateEnable);
                if (d_ValueY > 50 && that.navigateEnable == true) {
                    console.log("slide down")
                    if (typeof (T2D) == "function") {
                        T2D();
                        return;
                    }
                } else if (d_ValueY < -50 && that.navigateEnable == true) {
                    console.log("slide up")
                    if (typeof (D2T) == "function") {
                        D2T();
                        return;
                    }
                }

                if (d_ValueX > 50 && that.navigateEnable == true) {
                    console.log("slide right")
                    if (typeof (L2R) == "function") {
                        L2R();
                        return;
                    }
                } else if (d_ValueX < -50 && that.navigateEnable == true) {
                    console.log("slide left")
                    if (typeof (R2L) == "function") {
                        R2L();
                        return;
                    }
                }
            }
            that.touchStatus = this.TouchMode.cancel;
            if (that.touchTimer != 0) {
                clearInterval(that.touchTimer);
                that.touchTimer = 0;
            }
        } else if (touchItem.type == "touchcancel") {
            if (that.touchTimer != 0) {
                clearInterval(that.touchTimer);
                that.touchTimer = 0;
            }
        }
    }
};
 var dcmlib = require('dcm')
var TP = require('/modules/touch.js')

Page({

    /* 此方法在第一次显示窗体前发生 */
    onLoad: function (event) {
        // var page = this;
        TP.PageTouchInit(this);
        // var sysdcm = dcmlib.Open('system')
        // /* 绑定职务字段值修改回调 */
        // sysdcm.onChange('ble.mac', function ch(event) {
        //     var v = sysdcm.getItem(event) + ''
        //     page.setData({QRCode : {version : 4, source : v}});
        // })
        // this.sysdcm = sysdcm
    },

    /* 此方法展示窗体后发生 */
    onResume: function (event) {

    },

    /* 此方法点击页面时调用 */
    onPageTouch: function (event) {
        TP.PageTouchEvent(this, event,
            0,
            0,
            function () { pm.navigateBack({ value: "update" }) },
            0,
            0
        );
    },

    /* 当前页状态变化为显示时触发 */
    onShow: function (event) {
        // var v = this.sysdcm.getItem('ble.mac') + ''
        // // if (!v) {
        //     this.setData({QRCode : {version : 4, source : v}});
        // // }
        // // else {
        // //     this.setData({QRCode : {version : 3, source : 'unknown'}});
        // // }
    },

    /* 当前页状态变化为隐藏时触发 */
    onHide: function (event) {

    },

    /* 此方法关闭窗体前发生 */
    onExit: function (event) {
        TP.PageTouchUninit(this);
    },
});
   <?xml version="1.0" encoding="UTF-8"?>
<rtgui version="1.0">
<class>Page</class>
<widget class="Page" bindtouch="onPageTouch" name="page1">
<public>
<property name="background">255, 255, 255, 255</property>
</public>
<widgets>
<widget name="label3" class="label">
<public>
<property name="rect">0, 110, 240, 25</property>
<property name="align">HORIZONTAL | VERTICAL</property>
<property name="background">0, 212, 208, 200</property>
<property name="font">/system/fonts/hyqihei-55j.ttf, 20</property>
</public>
<property name="text">Hello World</property>
</widget>
</widgets>
</widget>
</rtgui>  �PNG

   IHDR           szz�   gAMA  ���a    cHRM  z&  ��  �   ��  u0  �`  :�  p��Q<   	pHYs     ��  ^IDATXG��PT��/�i�Lb4�bGHI�$4:�����Ĵ5i���.B̄4Չ�NfҖf��6N�jkZ�T1��tQ`a�'���0�n�eYy/,����.����o���s���|��iJ�BW�T	5���O!�Q)޽!z�^��\�罶t�Ν��n����?.�+��1h}���sKwo�͆��+���J	���;UL8�,���N;x�W��ѕ ���5E�*��ښws6_>���q����Oϧe����w�_��ՀT�	U������AS��^���=����fۻ!��p��[̀	]%>�l����<1�k&�
��V����P:���Z�b�d��\�u�z�������������x蘦��a2�-�n���3�Z����� ދ�ɽ֔أ��T���3�2:�6:�Q�_2�`QAV�s������k\��;�0����YC�C��:��o�G�KW R�*�3(��#�L����^$�p�ɫ������4�`�Gt�v9� �����7#��nSj�G(u!�Ԣ(C�1���l�+8����2xduA[��UM��³��0TJ���u��ߜ�Xt�����[ ��b�s�[Sъ�n<��%�V�-� �ȍ�����DA ��8������ �G~��$-`�Չ{�.̧�x�}�I7V�lC�)��g	v7�/jG�ɉ�Mu��ٰ@{6���W�|~��6Z\ggM[�񗐌����
ƕ��0����`]u;��ۃ4�ռ��Z^�9����Ximüc��;�:>�sg���( ��\|�@�
��^��'�����>�^�
���%�]����U��6�9ӎG8$B)� R%��n,-[�	�(��ԣ�7g�n�I�����m��y˴u������~�W�\TF�V�:ׅ���h�FS�N��Tm'�5���+��_�����\S@�XZ�~�����v(!�n\�?$)ZW��Ռ�jGl�yM������$��r��J?�8�F�!�"��ԏn_ CrPy��k����u�n,e��kv$���^�=P�/�������J���~��g���� �i��s�H�����OQ����x�Ð����X\ہR�W��q��t���d�G����f��.a�(v�.���65g�6�J���U[������؂:��`���V��(�<j�W��\��뇏�~����`kT��y7���ӎ	��V��4Uӊ��E��o:}R� ������* ���R�wd�ܧ<C�eC7^��} � �B �b�* ���|��20��!B��&��[�	���Ng`�L�-�`���x� k����,0s2�(�2E$��h��|ѫ\�]^l��Ħ�N�B1�
a�|5c ��� �{#���o���P�4�a�eAQ�y绔�od*
y���O��x�A8��1�s�q�i��d�h.c`+�p����� �H�&W{�a�o�ï�3��R�u�������O�����݆<2U!
��J���VBb9��_E��$��ă��P*�i�9�loCLa;R+�ӝ�)�a2�f$��X$2��re˩h%M�� f��{��q��%%�x���3����P��fnF�Mo32�v,��n�<��B�,!�2nN+����E�,+iÏ�}���Ua������H��a���/�C��V�<�G��'����x��S�+��	l��VtD�6$S�d��U��Yl�ԥ����)4�&�<�ɹ���і�iK6aSZjJM�MiV́]�lJ3ٔjBM�n�֔�K���t�-���r�r��e��`�����ÑLʰ�����a$E&:���h��q,�٭r'��m�}8���Z���?��>.~: H    IEND�B`��PNG

   IHDR         u.2   gAMA  ���a   tEXtSoftware Adobe ImageReadyq�e<   �IDAT8Oc� ��ң�l�ā@<�gR�����ف� �/,,��q��_;v��O	ްaÏ��̳ 3!F�F�г��>� �D5��� h�2�
0 [�l{(�Y�d�j����[@�A�>�QSS�9s�����***7�fkB� �Y�����]{{���'������qss{2b4`�X�K��2?�_ �" � ��@AAM� �!c4��O�    IEND�B`�  �PNG

   IHDR         k�w   gAMA  ���a   tEXtSoftware Adobe ImageReadyq�e<   �IDAT8Oc��c�� (q k�yx ;��������r�ob�$6����yvÆ��,Y��̙����� ŋ Ҙ�T�YCkk����4���;v����a�ĉ E� ң��6�u�O#�A�a�ƍ!khooe��iL�����5������@�15�q��������;jjj�B@$��q(�y�`x���� ��c4U    IEND�B`�     ZzH      <t=j'   
   hello_world示例 APP   CR 	   "�.
     �   m0\�<    �   슴L  �  �   e� �D  �  �   �&R�4  f  �   ��M�  �  �   �*a^�#  :  �   ��D��$  :  $  �\F��%  1   O  app.js app.json modules/touch.js pages/page1/page1.js pages/page1/page1.xml res/images/app.png res/images/scrollbar_handle_horizontal.9.png res/images/scrollbar_handle_vertical.9.png res/values/strings.bin   