class StringTooler{
  StringTooler();

  static List<String> getData(String data){
    RegExp reg = new RegExp(r"(http\S+) 复制此链接");
    // String data = "姗姗💗＠¥发了一个快手作品，一起来看！ http://kphshanghai.m.chenzhongtech.com/s/9ctVsLxo 复制此链接，打开【快手】直接观看！";
    Iterable<RegExpMatch> matches = reg.allMatches(data);
    for(Match m in matches){
      print(m.group(0));
      print(m.group(1));
      // await Core.instance.sqlTooler.add(m.group(0), m.group(1));
      return [data, m.group(1)];
    }
    return [];
  }

  static String getJs(String data){
    var js;
    if(data.indexOf("【快手】") != -1){
      js = [
        'var video = document.querySelector("video");',
        'var src = video.getAttribute("src");',
        'var poster = video.getAttribute("poster");',
        'JSON.stringify({src, poster});'
      ].join("");
    }
    else{
      js = [
        'var video = document.querySelector("video");',
        'var src = video.getAttribute("src");',
        'var s = document.getElementById("videoPoster").style.backgroundImage;',
        'var poster = s.match(/"(http\\S+)"/)[1];',
        'JSON.stringify({src, poster});'
      ].join("");
    }
    return js;
  }
}