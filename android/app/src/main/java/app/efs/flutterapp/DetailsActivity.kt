package app.efs.flutterapp

import android.os.Build
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.View
import android.webkit.WebChromeClient
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import kotlinx.android.synthetic.main.activity_details.*

/**
 * Created by ZhaoShulin on 2018/7/7 下午2:40.
 * <br>
 * Desc:
 * <br>
 */
class DetailsActivity : AppCompatActivity() {

    private val title by lazy {
        intent.getStringExtra("title")
    }
    private val slgn by lazy {
        intent.getStringExtra("slug")
    }

    fun getDetailWebUrl(slug: String): String {
        return "https://zhuanlan.zhihu.com/p/$slug"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_details)
        initToolsBar()
        web_view.apply {
            isVerticalScrollBarEnabled = false
            isHorizontalScrollBarEnabled = false
            webViewClient = WebViewClient()
            webChromeClient = object : WebChromeClient() {
                override fun onProgressChanged(view: WebView?, newProgress: Int) {
                    if (newProgress == 100) {
                        pb_webview.visibility = View.GONE
                    } else {
                        pb_webview.visibility = View.VISIBLE
                        pb_webview.progress = newProgress
                    }
                }
            }
            settings.javaScriptEnabled = true
            settings.blockNetworkImage = false
            settings.loadsImagesAutomatically = true
            settings.domStorageEnabled = true
            settings.allowFileAccess = true
            settings.defaultTextEncodingName = "UTF-8"
            settings.cacheMode = WebSettings.LOAD_NO_CACHE
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                settings.mixedContentMode = android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
            }
        }
        web_view.loadUrl(getDetailWebUrl(slgn))
    }

    private fun initToolsBar() {
        setSupportActionBar(toolbar)
        supportActionBar?.title = title
        toolbar.setNavigationOnClickListener { onBackPressed() }
    }
}