# iot


decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide.none
                  ),
                  counterText: '',
                  hintText: '请输入设备名称',
                  floatingLabelBehavior: FloatingLabelBehavior.never, // 取消文本上移效果
                ),


///title
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 54.w*3),
                            color: HhColors.trans,
                            child: Text(
                              '设备定位',
                              style: TextStyle(
                                  color: HhColors.blackTextColor,
                                  fontSize: 18.sp*3,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(23.w*3, 59.h*3, 0, 0),
                            padding: EdgeInsets.fromLTRB(0, 10.w, 20.w, 10.w),
                            color: HhColors.trans,
                            child: Image.asset(
                              "assets/images/common/back.png",
                              height: 17.w*3,
                              width: 10.w*3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
